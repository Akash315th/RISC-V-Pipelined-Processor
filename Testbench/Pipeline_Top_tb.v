`timescale 1ns/1ps

module tb();

reg clk = 0, rst;

Pipeline_top DUT(
    .clk(clk),
    .rst(rst)
);

always begin
    #50 clk = ~clk;
end



initial begin
    rst = 1'b0;
    #200;
    rst = 1'b1;
    #2000;
    $finish;
end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
end

endmodule