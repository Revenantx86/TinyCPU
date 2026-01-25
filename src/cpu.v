// File: src/cpu.v
module cpu (
    input wire clk,
    input wire reset,
    input wire [7:0] operand_a,
    input wire [7:0] operand_b,
    input wire opcode,          // 0 = ADD, 1 = SUB
    output reg [7:0] result
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'b0;
        end else begin
            case (opcode)
                1'b0: result <= operand_a + operand_b; // ADD
                1'b1: result <= operand_a - operand_b; // SUB
            endcase
        end
    end

endmodule