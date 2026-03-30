`include "ALU_decoder.v"
`include "main_decoder.v"

module Control_Unit_Top(
    Op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch,
    funct3, funct7, ALUControl
);

input [6:0] Op;
input [2:0] funct3;
input funct7;   

output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
output [1:0] ImmSrc;
output [2:0] ALUControl;

wire [1:0] ALUOp;

// Main Decoder 
main_decoder Main_Decoder(
    .op(Op),                  
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .MemWrite(MemWrite),     
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp)
);

// ALU Decoder 
alu_decoder ALU_Decoder(
    .ALUOp(ALUOp),
    .op5(Op[5]),             
    .funct3(funct3),
    .funct7(funct7),         
    .ALUControl(ALUControl)
);

endmodule