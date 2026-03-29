module Reg_file(A1, A2, A3, WD3, WE3, clk, rst, RD1, RD2);

input clk, rst;
input [4:0] A1, A2, A3;
input [31:0] WD3;
input WE3;

output [31:0] RD1, RD2;

reg [31:0] Registers [31:0];

assign RD1 = (!rst) ? 32'h00000000 : Registers[A1];
assign RD2 = (!rst) ? 32'h00000000 : Registers[A2];

always @(posedge clk) begin
    if (WE3)
    begin
        Registers[A3] <= WD3;
    end
end

initial begin
    Registers[9] = 32'h00000020;
end
endmodule