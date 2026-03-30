module Data_Memory(
    input [31:0] A,
    input [31:0] WD3,
    input clk,
    input WE,
    output [31:0] RD
);

reg [31:0] Data_MEM [1023:0];

// READ
assign RD = (WE == 1'b0) ? Data_MEM[A[31:2]] : 32'b0;

// WRITE
always @(posedge clk) begin
    if (WE)
        Data_MEM[A[31:2]] <= WD3;
end

endmodule