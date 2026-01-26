module alu (
    input  wire [7:0] operand_a,
    input  wire [7:0] operand_b,
    input  wire [2:0] opcode,
    output reg  [7:0] result,
    output wire       zero
);

// Simple ALU implementation
    always @(*) begin
        case (opcode)
            3'b000: result = operand_a + operand_b;       // ADD
            3'b001: result = operand_a - operand_b;       // SUB
            3'b010: result = operand_a & operand_b;       // AND
            3'b011: result = operand_a | operand_b;       // OR
            3'b100: result = operand_a ^ operand_b;       // XOR
            3'b101: result = ~operand_a;                  // NOT
            3'b110: result = operand_a << 1;              // SHL
            3'b111: result = operand_a >> 1;              // SHR
            default: result = 8'b0;
        endcase
    end

    // Zero flag is high if result is 0
    assign zero = (result == 8'b0);

endmodule