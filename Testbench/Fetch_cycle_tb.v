module tb();

reg clk, rst, PCSrcE;
reg [31:0] PCTargetE;

wire [31:0] InstrD, PCD, PCPlus4D;

fetch_cycle dut(
    .clk(clk),
    .rst(rst),
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

// Clock generation
always #50 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    PCSrcE = 0;
    PCTargetE = 32'h00000000;

    #100;
    rst = 0;

    #500;
    $finish;
end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
end

endmodule