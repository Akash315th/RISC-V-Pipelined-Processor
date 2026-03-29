module alu_decoder(ALUOp, op5, funct3, funct7, ALUControl);

input [1:0] ALUOp;
input op5, funct7;
input [2:0] funct3;
output [2:0] ALUControl;

wire [1:0] concatenation;

assign concatenation = {op5, funct7};

assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :   // ADD
                    (ALUOp == 2'b01) ? 3'b001 :   // SUB

                    (ALUOp == 2'b10 && funct3 == 3'b010 && concatenation == 2'b11) ? 3'b001 : // SUB
                    (ALUOp == 2'b10 && funct3 == 3'b010) ? 3'b000 : // ADD
                    (ALUOp == 2'b10 && funct3 == 3'b110) ? 3'b011 : // OR
                    (ALUOp == 2'b10 && funct3 == 3'b111) ? 3'b010 : // AND

                    3'b000;

endmodule