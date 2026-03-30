`include "Fetch_Cycle.v"
`include "Decode_Cycle.v"
`include "Execute_Cycle.v"
`include "Memory_Cycle.v"
`include "Writeback_Cycle.v"

module Pipeline_top (clk, rst);

input clk, rst;

// Wires 
wire PCSrcE;

wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
wire RegWriteM, MemWriteM, ResultSrcM;
wire RegWriteW, ResultSrcW;

wire [2:0] ALUControlE;

wire [4:0] RD_E, RD_M, RD_W;

wire [31:0] PCTargetE;
wire [31:0] InstrD, PCD, PCPlus4D;
wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
wire [31:0] PCE, PCPlus4E;

wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

wire [31:0] ResultW;

// Fetch Stage
fetch_cycle Fetch(
    .clk(clk), 
    .rst(rst), 
    .PCSrcE(PCSrcE), 
    .PCTargetE(PCTargetE), 
    .InstrD(InstrD), 
    .PCD(PCD), 
    .PCPlus4D(PCPlus4D)
);

// Decode Stage 
decode_cycle Decode(
    .clk(clk), 
    .rst(rst),
    .RegWriteW(RegWriteW),
    .RDW(RD_W),
    .InstrD(InstrD), 
    .PCD(PCD), 
    .PCPlus4D(PCPlus4D), 
    .ResultW(ResultW),

    .RegWriteE(RegWriteE), 
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE), 
    .ResultSrcE(ResultSrcE), 
    .BranchE(BranchE),

    .ALUControlE(ALUControlE),
    .RD1_E(RD1_E), 
    .RD2_E(RD2_E), 
    .Imm_Ext_E(Imm_Ext_E),
    .RD_E(RD_E),

    .PCE(PCE), 
    .PCPlus4E(PCPlus4E)
);

//  Execute Stage
execute_cycle Execute(
    .clk(clk), 
    .rst(rst), 
    .RegWriteE(RegWriteE), 
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE), 
    .ResultSrcE(ResultSrcE), 
    .BranchE(BranchE),   

    .ALUControlE(ALUControlE), 
    .RD1_E(RD1_E), 
    .RD2_E(RD2_E), 
    .Imm_Ext_E(Imm_Ext_E), 
    .RD_E(RD_E), 

    .PCE(PCE), 
    .PCPlus4E(PCPlus4E),

    .PCTargetE(PCTargetE), 
    .PCSrcE(PCSrcE),

    .RegWriteM(RegWriteM), 
    .MemWriteM(MemWriteM), 
    .ResultSrcM(ResultSrcM),

    .RD_M(RD_M), 
    .PCPlus4M(PCPlus4M), 
    .WriteDataM(WriteDataM), 
    .ALU_ResultM(ALU_ResultM)
);

// Memory Stage 
memory_cycle Memory(
    .clk(clk), 
    .rst(rst),

    .RegWriteM(RegWriteM), 
    .MemWriteM(MemWriteM), 
    .ResultSrcM(ResultSrcM),

    .RD_M(RD_M), 
    .PCPlus4M(PCPlus4M), 
    .WriteDataM(WriteDataM), 
    .ALU_ResultM(ALU_ResultM),

    .RegWriteW(RegWriteW), 
    .ResultSrcW(ResultSrcW),

    .RD_W(RD_W), 
    .PCPlus4W(PCPlus4W), 
    .ALU_ResultW(ALU_ResultW), 
    .ReadDataW(ReadDataW)
);

// Writeback Stage 
writeback_cycle Writeback(
    .clk(clk), 
    .rst(rst), 
    .ResultSrcW(ResultSrcW), 
    .PCPlus4W(PCPlus4W), 
    .ALU_ResultW(ALU_ResultW), 
    .ReadDataW(ReadDataW), 
    .ResultW(ResultW)
);

endmodule