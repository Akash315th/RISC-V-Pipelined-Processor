`include "Control_Unit_Top.v"
`include "Register_files.v"
`include "Sign_Extend.v"

module decode_cycle(
    input clk, rst,
    input RegWriteW,
    input [4:0] RDW,
    input [31:0] InstrD, PCD, PCPlus4D, ResultW,

    output RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE,
    output [2:0] ALUControlE,
    output [31:0] RD1_E, RD2_E, Imm_Ext_E,
    output [4:0] RD_E,
    output [31:0] PCE, PCPlus4E
);

// Internal wires
wire RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
wire [1:0] ImmSrcD;
wire [2:0] ALUControlD;
wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

// Pipeline registers
reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, ResultSrcD_r, BranchD_r;
reg [2:0] ALUControlD_r;
reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
reg [4:0] RD_D_r;
reg [31:0] PCD_r, PCPlus4D_r;

// Control Unit
Control_Unit_Top ControlTopModule(
    .Op(InstrD[6:0]), 
    .RegWrite(RegWriteD), 
    .ImmSrc(ImmSrcD), 
    .ALUSrc(ALUSrcD), 
    .MemWrite(MemWriteD), 
    .ResultSrc(ResultSrcD), 
    .Branch(BranchD),
    .funct3(InstrD[14:12]), 
    .funct7(InstrD[30]), 
    .ALUControl(ALUControlD)
);

// Register File
Reg_file Register_File(
    .A1(InstrD[19:15]), 
    .A2(InstrD[24:20]), 
    .A3(RDW), 
    .WD3(ResultW), 
    .WE3(RegWriteW), 
    .clk(clk), 
    .rst(rst), 
    .RD1(RD1_D), 
    .RD2(RD2_D)
);

// Sign Extend
Sign_Extend Sign_Extend_inst(
    .In(InstrD), 
    .Imm_Ext(Imm_Ext_D),
    .ImmSrc(ImmSrcD)
);

// Pipeline Register (D → E)
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        RegWriteD_r <= 0;
        ALUSrcD_r   <= 0;
        MemWriteD_r <= 0;
        ResultSrcD_r<= 0;
        BranchD_r   <= 0;
        ALUControlD_r <= 0;
        RD1_D_r <= 0;
        RD2_D_r <= 0;
        Imm_Ext_D_r <= 0;
        RD_D_r <= 0;
        PCD_r <= 0;
        PCPlus4D_r <= 0;
    end else begin
        RegWriteD_r <= RegWriteD;
        ALUSrcD_r   <= ALUSrcD;
        MemWriteD_r <= MemWriteD;
        ResultSrcD_r<= ResultSrcD;
        BranchD_r   <= BranchD;
        ALUControlD_r <= ALUControlD;
        RD1_D_r <= RD1_D;
        RD2_D_r <= RD2_D;
        Imm_Ext_D_r <= Imm_Ext_D;
        RD_D_r <= InstrD[11:7];
        PCD_r <= PCD;
        PCPlus4D_r <= PCPlus4D;
    end
end

// Output assignments
assign RegWriteE = RegWriteD_r;
assign ALUSrcE   = ALUSrcD_r;
assign MemWriteE = MemWriteD_r;
assign ResultSrcE= ResultSrcD_r;
assign BranchE   = BranchD_r;
assign ALUControlE = ALUControlD_r;

assign RD1_E = RD1_D_r;
assign RD2_E = RD2_D_r;
assign Imm_Ext_E = Imm_Ext_D_r;
assign RD_E = RD_D_r;
assign PCE = PCD_r;
assign PCPlus4E = PCPlus4D_r;

endmodule