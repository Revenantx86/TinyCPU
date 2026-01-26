module alu (
    input  wire [7:0] operand_a,
    input  wire [7:0] operand_b,
    input  wire [2:0] opcode,
    output reg  [7:0] result,
    output wire       zero
);

// Simple ALU implementation

    // Zero flag is high if result is 0
    assign zero = (result == 8'b0);

endmodule