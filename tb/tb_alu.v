// File: tb/tb_alu.v
`timescale 1ns/1ns

module tb_alu;

    // --- Signals ---
    reg  [7:0] operand_a;
    reg  [7:0] operand_b;
    reg  [2:0] opcode;
    wire [7:0] result;
    wire       zero;

    // --- Instantiate the ALU ---
    alu uut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );

    integer errors = 0;

    // --- Helper Task to Check Results ---
    task check;
        input [2:0] op_sel;
        input [7:0] in_a;
        input [7:0] in_b;
        input [7:0] exp_res;
        input       exp_zero;
        begin
            operand_a = in_a;
            operand_b = in_b;
            opcode    = op_sel;
            #10; // Wait for logic to settle

            if (result !== exp_res || zero !== exp_zero) begin
                $display("❌ FAIL: Op=%b | A=%d B=%d | Got: %d (Z=%b) | Expected: %d (Z=%b)", 
                         op_sel, in_a, in_b, result, zero, exp_res, exp_zero);
                errors = errors + 1;
            end else begin
                // Optional: Uncomment to see passing tests
                // $display("✅ PASS: Op=%b | %d op %d = %d", op_sel, in_a, in_b, result);
            end
        end
    endtask

    // --- Main Test Loop ---
    initial begin
        $display("\n--- Starting ALU Verification ---");

        // 1. Test ADD (000) - Normal
        check(3'b000, 8'd10, 8'd20, 8'd30, 1'b0);
        
        // 2. Test ADD (000) - Overflow behavior (wrap around)
        // 255 + 1 = 0 (8-bit) -> Zero flag should be 1
        check(3'b000, 8'd255, 8'd1, 8'd0, 1'b1);

        // 3. Test SUB (001)
        check(3'b001, 8'd50, 8'd20, 8'd30, 1'b0);

        // 4. Test SUB (001) - Zero Result
        check(3'b001, 8'd10, 8'd10, 8'd0, 1'b1);

        // 5. Test AND (010)
        // 1100 (12) & 1010 (10) = 1000 (8)
        check(3'b010, 8'd12, 8'd10, 8'd8, 1'b0);

        // 6. Test OR (011)
        // 1100 (12) | 1010 (10) = 1110 (14)
        check(3'b011, 8'd12, 8'd10, 8'd14, 1'b0);

        // 7. Test XOR (100)
        // 1111 ^ 1111 = 0000
        check(3'b100, 8'hFF, 8'hFF, 8'h00, 1'b1);

        // 8. Test NOT (101) - Only uses Operand A
        // ~00000000 = 11111111 (255)
        check(3'b101, 8'd0, 8'd0, 8'd255, 1'b0);

        // 9. Test SHL (110) - Shift Left
        // 1 (00000001) << 1 = 2 (00000010)
        check(3'b110, 8'd1, 8'd0, 8'd2, 1'b0);

        // 10. Test SHR (111) - Shift Right
        // 4 (00000100) >> 1 = 2 (00000010)
        check(3'b111, 8'd4, 8'd0, 8'd2, 1'b0);


        // --- Final Report ---
        if (errors > 0) begin
            $display("\n-----------------------------------------");
            $display("🔴 FAILED: Found %0d errors.", errors);
            $display("-----------------------------------------\n");
            $finish(1); // Return Error Code 1 to GitHub
        end else begin
            $display("\n-----------------------------------------");
            $display("🟢 SUCCESS: All ALU tests passed!");
            $display("-----------------------------------------\n");
            $finish(0); // Return Success Code 0 to GitHub
        end
    end

endmodule