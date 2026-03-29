`timescale 1ns/1ps

module execute_cycle_tb;

// Inputs
reg clk;
reg rst;
reg RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
reg [2:0] ALUControlE;
reg [31:0] RD1_E, RD2_E, Imm_Ext_E;
reg [4:0] RD_E;
reg [31:0] PCE, PCPlus4E;

// Outputs
wire [31:0] PCTargetE;
wire PCSrcE;
wire RegWriteM, MemWriteM, ResultSrcM;
wire [4:0] RD_M;
wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

// Instantiate DUT
execute_cycle DUT(
    .clk(clk), .rst(rst),
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
    .PCPlus4E(PCPlus4E),

    .PCTargetE(PCTargetE),
    .PCSrcE(PCSrcE),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .RD_M(RD_M),
    .PCPlus4M(PCPlus4M),
    .WriteDataM(WriteDataM),
    .ALU_ResultM(ALU_ResultM)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $display("Starting Execute Cycle Testbench...");

    // Initialize
    clk = 0;
    rst = 0;
    RegWriteE = 0;
    ALUSrcE = 0;
    MemWriteE = 0;
    ResultSrcE = 0;
    BranchE = 0;
    ALUControlE = 3'b000;
    RD1_E = 0;
    RD2_E = 0;
    Imm_Ext_E = 0;
    RD_E = 0;
    PCE = 0;
    PCPlus4E = 0;

    // Apply reset
    #10 rst = 1;

    // ---------------------------------
    // Test 1: ADD operation
    // ---------------------------------
    RD1_E = 10;
    RD2_E = 20;
    ALUSrcE = 0;        // Use RD2
    ALUControlE = 3'b000; // ADD
    RegWriteE = 1;

    #10;

    // ---------------------------------
    // Test 2: SUB operation
    // ---------------------------------
    RD1_E = 30;
    RD2_E = 10;
    ALUControlE = 3'b001; // SUB

    #10;

    // ---------------------------------
    // Test 3: Immediate operation
    // ---------------------------------
    RD1_E = 15;
    Imm_Ext_E = 5;
    ALUSrcE = 1;        // Use immediate

    #10;

    // ---------------------------------
    // Test 4: Branch (Zero condition)
    // ---------------------------------
    RD1_E = 20;
    RD2_E = 20;
    ALUSrcE = 0;
    ALUControlE = 3'b001; // SUB → zero
    BranchE = 1;

    PCE = 32'h1000;
    Imm_Ext_E = 32'h0004;

    #10;

    // ---------------------------------
    // Test 5: No branch
    // ---------------------------------
    RD1_E = 20;
    RD2_E = 10;
    BranchE = 1;

    #20;

    $display("Simulation Finished.");
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time=%0t | ALU_Result=%d | WriteData=%d | PCSrc=%b | PCTarget=%h",
             $time, ALU_ResultM, WriteDataM, PCSrcE, PCTargetE);
end

endmodule