`include "P_C.v"
`include "Instruction_memory.v"
`include "Register_File.v"
`include "Sign_extend.v"
`include "ALU_with_flag.v"
`include "Control_unit_top.v"
`include "Data_Mem.v"
`include "PC_Adder.v"
module Single_Cycle_Top(clk,rst);
input clk,rst;
wire [31:0]PC_Top;
wire [31:0]RD_Instr;
wire [31:0]RD1_Top,Imm_Ext_Top,ALUControl_Top,ALUResult,readData,PCPlus4;
wire RegWrite;
PC_module P_C(
    .clk(clk),
    .rst(rst),
    .PC(PC_Top)
    .PC_next(PCPlus4)
);
Instruction_memory Instr_Mem(
    .rst(rst),
    .A(PC_Top),
    .RD(RD_Instr)
);

Register_File Reg_file(
        .A1(RD_Instr[19:15]),
        .A2(),
        .A3(RD_Instr[11:7]),
        .WD3(readData),
        .WE3(RegWrite),
        .RD1(RD1_Top),
        .RD2(),
        .clk(clk),
        .rst(rst)

);

Sign_extend SignExtend(
    .Imm(RD_Instr),
    .Imm_Ext(Imm_Ext_Top)
);

ALU_with_flag alu(
    .A(RD1_Top),          
    .B(Imm_Ext_Top),          
    .ALUControl(ALUControl_Top),
    .Result(),
    .N(),  
    .Z(),  
    .C(),                
    .V() 
);

Control_unit_Top Control_Unit_top(
    .Op(RD_Instr[6:0]),
    .RegWrite(RegWrite),
    .ImmSrc(),
    ALUSrc,
    MemWrite,
    .ResultSrc,
    Branch,
    .funct3([14:12]),
    funct7,
    ALUControl(ALUControl_Top)
    );

Data_Mem Data_Memory(
    WD,
    .A(ALUResult),
    clk,
    WE,
    .RD(readData)
);

PC_Adder PC_Adder(
    .a(PC),
    .b(32'd4),
    .c(PCPlus4)
);

endmodule