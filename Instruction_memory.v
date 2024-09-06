module Instr_Mem(A,RD,rst);
input [31:0]A;
input rst;
output [31:0]RD;

reg [31:0] Mem[1023:0]//1024 registers of size 32 bits each

assign RD=(rst == 1'b0)? 32'b00000: Mem[A[31:2]];

endmodule