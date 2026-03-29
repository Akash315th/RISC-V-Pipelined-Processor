`timescale 1ns/1ps

module memory_cycle_tb;

// Inputs
reg clk;
reg rst;
reg RegWriteM, MemWriteM, ResultSrcM;
reg [4:0] RD_M;
reg [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

// Outputs
wire RegWriteW, ResultSrcW;
wire [4:0] RD_W;
wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

// Instantiate DUT
memory_cycle DUT(
    .clk(clk),
    .rst(rst),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .RD_M(RD_M),
    .PCPlus4M(PCPlus4M),
    .WriteDataM(WriteDataM),
    .ALU_ResultM(ALU_ResultM),

    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .RD_W(RD_W),
    .PCPlus4W(PCPlus4W),
    .ALU_ResultW(ALU_ResultW),
    .ReadDataW(ReadDataW)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $display("Starting Memory Cycle Testbench...");

    // Initialize
    clk = 0;
    rst = 0;
    RegWriteM = 0;
    MemWriteM = 0;
    ResultSrcM = 0;
    RD_M = 0;
    PCPlus4M = 0;
    WriteDataM = 0;
    ALU_ResultM = 0;

    // Apply reset
    #10 rst = 1;

    // ---------------------------------
    // Test 1: Memory Write (STORE)
    // ---------------------------------
    MemWriteM = 1;
    WriteDataM = 32'd100;
    ALU_ResultM = 32'd4;   // Address = 4

    #10;

    // ---------------------------------
    // Test 2: Memory Read (LOAD)
    // ---------------------------------
    MemWriteM = 0;
    ALU_ResultM = 32'd4;   // Read same address
    ResultSrcM = 1;

    #10;

    // ---------------------------------
    // Test 3: Pipeline Register Check
    // ---------------------------------
    RegWriteM = 1;
    RD_M = 5'd5;
    PCPlus4M = 32'h1004;

    #20;

    $display("Simulation Finished.");
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time=%0t | ReadData=%d | ALU_Result=%d | RD=%d | RegWriteW=%b",
             $time, ReadDataW, ALU_ResultW, RD_W, RegWriteW);
end

endmodule