module Instr_Mem(A, RD);

input [31:0] A;
output [31:0] RD;

reg [31:0] Mem [1023:0];

// Read operation (NO RESET HERE)
assign RD = Mem[A[31:2]];

// Initialization
initial begin
    Mem[0] = 32'hFFC4A303; 
    Mem[1] = 32'h00100093; 
    Mem[2] = 32'h00200113; 
end

endmodule