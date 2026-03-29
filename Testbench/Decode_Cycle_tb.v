`timescale 1ns/1ps

module decode_cycle_tb;

// Inputs
reg clk;
reg rst;
reg RegWriteW;
reg [4:0] RDW;
reg [31:0] InstrD, PCD, PCPlus4D, ResultW;

// Outputs
wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
wire [2:0] ALUControlE;
wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
wire [4:0] RD_E;
wire [31:0] PCE, PCPlus4E;

// Instantiate DUT
decode_cycle DUT (
    .clk(clk),
    .rst(rst),
    .RegWriteW(RegWriteW),
    .RDW(RDW),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .ResultW(ResultW),

    .RegWriteE(RegWriteE),
    .ALUSrcE(ALUSrcE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .BranchE(BranchE),
    .ALUControlE(ALUControlE),
    .RD1_E(RD1_E),
    .RD2_E(RD2_E),
    .Imm_Ext_E(Imm_Ext_E),
    .RD_E(RD_E),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $display("Starting Decode Cycle Testbench...");
    
    // Initialize
    clk = 0;
    rst = 0;
    RegWriteW = 0;
    RDW = 0;
    InstrD = 0;
    PCD = 0;
    PCPlus4D = 0;
    ResultW = 0;

    // Apply reset
    #10;
    rst = 1;

    // ---------------------------
    // Test Case 1: ADD instruction
    // ---------------------------
    // R-type: add x3, x1, x2
    // opcode = 0110011
    InstrD = 32'b0000000_00010_00001_000_00011_0110011;

    RegWriteW = 1;
    RDW = 5'd1;
    ResultW = 32'd10;   // Write 10 into x1

    #10;

    RDW = 5'd2;
    ResultW = 32'd20;   // Write 20 into x2

    #10;

    PCD = 32'h1000;
    PCPlus4D = 32'h1004;

    #20;

    // ---------------------------
    // Test Case 2: ADDI instruction
    // ---------------------------
    // addi x4, x1, 5
    InstrD = 32'b000000000101_00001_000_00100_0010011;

    #20;

    // ---------------------------
    // Test Case 3: Branch
    // ---------------------------
    // beq x1, x2, offset
    InstrD = 32'b0000000_00010_00001_000_00000_1100011;

    #20;

    // Finish simulation
    $display("Simulation Finished.");
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time=%0t | RD1=%d RD2=%d Imm=%d | ALUCtrl=%b | RegWriteE=%b",
              $time, RD1_E, RD2_E, Imm_Ext_E, ALUControlE, RegWriteE);
end

endmodule