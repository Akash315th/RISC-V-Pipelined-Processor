`timescale 1ns/1ps

module writeback_cycle_tb;

// Inputs
reg clk;
reg rst;
reg ResultSrcW;
reg [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

// Output
wire [31:0] ResultW;

// Instantiate DUT
writeback_cycle DUT(
    .clk(clk),
    .rst(rst),
    .ResultSrcW(ResultSrcW),
    .PCPlus4W(PCPlus4W),
    .ALU_ResultW(ALU_ResultW),
    .ReadDataW(ReadDataW),
    .ResultW(ResultW)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    $display("Starting Writeback Cycle Testbench...");

    // Initialize
    clk = 0;
    rst = 0;
    ResultSrcW = 0;
    PCPlus4W = 0;
    ALU_ResultW = 0;
    ReadDataW = 0;

    // Apply reset
    #10 rst = 1;

    // -----------------------------
    // Test 1: ALU Result selected
    // -----------------------------
    ALU_ResultW = 32'd50;
    ReadDataW = 32'd100;
    ResultSrcW = 0;   // select ALU

    #10;

    // -----------------------------
    // Test 2: Memory Data selected
    // -----------------------------
    ResultSrcW = 1;   // select memory

    #10;

    // -----------------------------
    // Test 3: Change values
    // -----------------------------
    ALU_ResultW = 32'd200;
    ReadDataW = 32'd500;
    ResultSrcW = 0;

    #10;

    ResultSrcW = 1;

    #10;

    $display("Simulation Finished.");
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time=%0t | Result=%d | ALU=%d | MEM=%d | Sel=%b",
              $time, ResultW, ALU_ResultW, ReadDataW, ResultSrcW);
end

endmodule