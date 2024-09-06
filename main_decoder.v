module main_decoder(op,zero,RegWrite,MemWrite,ALUSrc,ResultSrc,ImmSrc,ALUop,PCSrc);
    input zero;
    input [6:0]op;
    output RegWrite,MemWrite,ResultSrc,ALUSrc,PCSrc; 
    output [1:0]ImmSrc, ALUop;

    //interim wires
    wire branch;

    assign RegWrite =([op == 7'b0000011]|[op == 7'b0110011])? 1'b1 : 1'b0//rewrite is 1 for LW anf Rtype instructions
    assign MemWrite =([op == 7'b0100011])? 1'b1:1'b0; //SW
    assign ResultSrc = ([op == 7'b0000011])? 1'b1 : 1'b0//LW
    assign ALUSrc = ([op == 7'b0000011]|[op == 7'b0100011])? 1'b1 : 1'b0;// LW and SW
    assign branch = ([op == 7'b1100011])? 1'b1 : 1'b0;//BEQ
    assign Immsrc = ([op == 7'b0100011])? 2'b01: ([op == 7'b1100011])? 2'b10: 2'b00;//SW and BEQ consider dont cares as 00
    assign ALUop = ([op == 7'b0110011])? 2'b10 : ([op == 7'b1100011])? 2'b01 : 2'b00;//rtype beq
    assign PCSrc = zero & branch;
    

endmodule