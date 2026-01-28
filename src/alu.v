module alu (
    input  wire [7:0] operand_a,
    input  wire [7:0] operand_b,
    input  wire [2:0] opcode,
    output reg  [7:0] result,
    output wire       zero
);
always @(*) begin
    case (opcode)
        3*b000: result = operand_a + operand_b
        3*b001: result = operand_a - operand_b
        3*b010: result = operand_a & operand_b
        3*b011: result = operand_a | operand_b
        default: result = 8*b0;
    endcase  
end

// Simple ALU implementation

    // Zero flag is high if result is 0
    assign zero = (result == 8'b0);

endmodule