module Reg_file(A1,A2,A3,WD3,WE3,RD1,RD2,clk,rst)

input clk,rst;
input [31:0] WD3;
input [4:0] A1,A2,A3;

output [31:0] RD1,RD2;
//creation of memory
reg [31:0]registers[31:0];

//read functionality
assign RD1 = (!rst) ? 32'h00000000 : registers[A1] ;
assign RD2 = (!rst) ? 32'h00000000 : registers[A2] ;

//write data
always @ (posedge clk) begin
    if (WE3)
    begin
        registers[A3]<=WD3;
    end
end



endmodule