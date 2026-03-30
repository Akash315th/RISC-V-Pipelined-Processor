`include "PC.v"
`include "Instruction_Memory.v"

module fetch_cycle(clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);

input clk, rst;
input PCSrcE;
input [31:0] PCTargetE;

output [31:0] InstrD;
output [31:0] PCD, PCPlus4D;

wire [31:0] PC_next, PC_current, PCPlus4F;
wire [31:0] InstrF;

reg [31:0] InstrF_reg;
reg [31:0] PCF_reg, PCPlus4F_reg;

// MUX: select next PC
Mux PC_mux (
    .a(PCPlus4F),
    .b(PCTargetE),
    .s(PCSrcE),
    .c(PC_next)
);

// Program Counter
PC_Module PC (
    .clk(clk),
    .rst(rst),
    .PC(PC_current),
    .PC_Next(PC_next)
);

// Instruction Memory
Instr_Mem IM (
    .A(PC_current),
    .RD(InstrF)
);

// PC + 4
PC_Adder PC_add (
    .a(PC_current),
    .b(32'h4),
    .c(PCPlus4F)
);

// IF/ID Pipeline Register
always @(posedge clk) begin
    if (rst) begin
        InstrF_reg <= 32'b0;
        PCF_reg <= 32'b0;
        PCPlus4F_reg <= 32'b0;
    end else begin
        InstrF_reg <= InstrF;
        PCF_reg <= PC_current;
        PCPlus4F_reg <= PCPlus4F;
    end
end

// Outputs (NO reset condition here)
assign InstrD = InstrF_reg;
assign PCD = PCF_reg;
assign PCPlus4D = PCPlus4F_reg;

endmodule