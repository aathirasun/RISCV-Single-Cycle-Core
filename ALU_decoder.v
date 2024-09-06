module ALU_decoder( ALUop, funct3,funct7,ALUControl,op5);
    input funct7,op5;
    input [2:0] funct3;
    output [2:0] ALUControl;

    //interim wire
    wire [1:0] concatenation = {op5,funct7};

    assign ALUControl = (ALUop == 2'b00)? 3'b000: 
                        (ALUop == 2'b01)? 3'b001:
                        ((ALUop == 2'b01) & (funct3 == 3'b010))? 3'b001:
                        ((ALUop == 2'b01) & (funct3 == 3'b110))? 3'b011:
                        ((ALUop == 2'b01) & (funct3 == 3'b111))? 3'b010:
                        ((ALUop == 2'b01) & (concatenation == 2'b11))? 3'b001:
                        ((ALUop == 2'b01) & (concatenation != 2'b11))? 3'b000: 3'b000:

                       
endmodule