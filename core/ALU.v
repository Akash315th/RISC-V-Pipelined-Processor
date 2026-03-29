module alu(A, B, ALUControl, Result, Z, N, V, C);

input [31:0] A, B;
input [2:0] ALUControl;

output [31:0] Result;
output Z, N, V, C;

wire [31:0] a_and_b;
wire [31:0] a_or_b;
wire [31:0] not_b;

wire [31:0] mux_1;
wire [31:0] sum;
wire cout;

wire [31:0] slt;
wire [31:0] mux_2;

// AND / OR
assign a_and_b = A & B;
assign a_or_b  = A | B;

// NOT B
assign not_b = ~B;

// ADD / SUB control
assign mux_1 = (ALUControl[0] == 1'b0) ? B : not_b;

// ADD / SUB operation
assign {cout, sum} = A + mux_1 + ALUControl[0];

// SLT
assign slt = {31'b0, sum[31]};

// Final MUX
assign mux_2 = (ALUControl == 3'b000) ? sum : 
               (ALUControl == 3'b001) ? sum : 
               (ALUControl == 3'b010) ? a_and_b : 
               (ALUControl == 3'b011) ? a_or_b :
               (ALUControl == 3'b101) ? slt : 
               32'h00000000;

// Output
assign Result = mux_2;

// Flags
assign Z = &(~Result);         // Zero
assign N = Result[31];         // Negative
assign C = cout & (~ALUControl[1]);  // Carry
assign V = (~ALUControl[1]) & 
           (A[31] ^ sum[31]) & 
           (~(A[31] ^ B[31] ^ ALUControl[0])); // Overflow

endmodule