module alu(A,B,ALUControl,Result):
input [31:0]A,B;
input [2:0]ALUControl;
output [31:0]Result;

wire [31:0]a_and_b;
wire [31:0]a_or_b;
wire [31:0]not_b;

wire [31:0]mux_1;
wire [31:0]mux_2;

wire [31:0]sum;

//logic and
assign a_and_b= A & B;
//or
assign a_or_b= A | B;
//not
assign not_b=~B;

//mux 2x1
assign mux_1=(ALUControl[0] == 1'b0)?B:not_B;

//addition and subtraction
assign sum= A + mux_1 + ALUControl[0];

//mux 4x1
assign mux2=(ALUControl[1:0] == 2'b00)?sum:
            (ALUControl[1:0] == 2'b01)?sum:
            (ALUControl[1:0]==2'b10)? a_and_b: a_or_b;
result=mux_2;


endmodule
