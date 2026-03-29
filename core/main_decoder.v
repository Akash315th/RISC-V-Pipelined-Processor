module main_decoder(op, zero, RegWrite, MemWrite, ResultSrc, ALUSrc, ImmSrc, ALUOp, PCSrc, Branch);

input zero;
input [6:0] op;

output RegWrite, MemWrite, ResultSrc, ALUSrc, PCSrc, Branch;
output [1:0] ImmSrc, ALUOp;

wire branch;

// RegWrite
assign RegWrite = ((op == 7'b0000011) || (op == 7'b0110011)) ? 1'b1 : 1'b0;

// MemWrite
assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;

// ResultSrc
assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0;

// ALUSrc
assign ALUSrc = ((op == 7'b0000011) || (op == 7'b0100011)) ? 1'b1 : 1'b0;

// Branch internal
assign branch = (op == 7'b1100011);

// expose Branch
assign Branch = branch;

// Immediate source
assign ImmSrc = (op == 7'b0100011) ? 2'b01 :
                (op == 7'b1100011) ? 2'b10 :
                2'b00;

// ALUOp
assign ALUOp = (op == 7'b0110011) ? 2'b10 :
               (op == 7'b1100011) ? 2'b01 :
               2'b00;

// PCSrc
assign PCSrc = zero && branch;

endmodule