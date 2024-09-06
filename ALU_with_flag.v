module alu(
    input [31:0] A,          // 32-bit input operand A
    input [31:0] B,          // 32-bit input operand B
    input [2:0] ALUControl,  // 3-bit control signal to select the ALU operation
    output [31:0] Result,    // 32-bit output result of the ALU operation
    output N,                // Negative flag: Set if Result is negative
    output Z,                // Zero flag: Set if Result is zero
    output C,                // Carry flag: Set if there is a carry out
    output V                 // Overflow flag: Set if there is signed overflow
);

    // Internal signals
    wire [31:0] a_and_b;     // Result of bitwise AND between A and B
    wire [31:0] a_or_b;      // Result of bitwise OR between A and B
    wire [31:0] not_b;       // Bitwise negation of B
    wire [31:0] mux_1;       // Output of 2x1 multiplexer, selects between B and not_b
    wire [31:0] mux_2;       // Output of 4x1 multiplexer, selects the final ALU result
    wire cout;               // Carry out from the addition operation
    wire slt;                // Set-less-than result, indicates if A is less than B
    wire [31:0] sum;         // Result of the addition/subtraction operation

    // Bitwise AND operation
    assign a_and_b = A & B;

    // Bitwise OR operation
    assign a_or_b = A | B;

    // Bitwise NOT operation (negation of B)
    assign not_b = ~B;

    // 2x1 Multiplexer: Selects between B and not_b based on ALUControl[0]
    assign mux_1 = (ALUControl[0] == 1'b0) ? B : not_b;

    // Addition/Subtraction operation
    // The sum is calculated with mux_1 and ALUControl[0] to support subtraction
    assign {cout, sum} = A + mux_1 + ALUControl[0];

    // Set-less-than (SLT) operation
    // Checks if A is less than B using the most significant bit of the sum
    assign slt = 31'b{000000000000000000000000000000, sum[31]};

    // 4x1 Multiplexer: Selects the final ALU result based on ALUControl
    assign mux_2 = (ALUControl[2:0] == 3'b000) ? sum :
                   (ALUControl[2:0] == 3'b001) ? sum :
                   (ALUControl[2:0] == 3'b010) ? a_and_b :
                   (ALUControl[2:0] == 3'b011) ? a_or_b :
                   (ALUControl[2:0] == 3'b101) ? slt :
                   32'h00000000;  // Default case

    // Assign the result of the multiplexer to the output Result
    assign Result = mux_2;

    // Zero flag (Z): Set if the result is zero (all bits of Result are low)
    assign Z = &(~Result);

    // Negative flag (N): Set if the most significant bit of Result is high
    assign N = Result[31];

    // Carry flag (C): Set if there is a carry out from the addition/subtraction
    assign C = cout & ~(ALUControl[1]);

    // Overflow flag (V): Set if there is signed overflow in addition/subtraction
    assign V = (~ALUControl[1] & (A[31] ^ sum[31])) & (~(A[31] ^ B[31] ^ ALUControl[0]));

endmodule
