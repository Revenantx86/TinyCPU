// File: tb/tb_inst_mem.v
`timescale 1ns/1ns

module tb_inst_mem;

    // --- Signals ---
    reg  [7:0] address;
    wire [15:0] instruction;
    integer errors = 0;

    // --- Instantiate the DUT ---
    inst_mem uut (
        .address(address),
        .instruction(instruction)
    );

    // --- Main Test ---
    initial begin
        $display("\n--- Starting Instruction Memory Verification ---");
        
        // 1. Test Address 0 (Should match the first line of program.hex)
        address = 8'd0;
        #5;
        if (instruction !== 16'h1122) begin
            $display("❌ FAIL: Addr 0. Expected 1122, Got %h", instruction);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Addr 0 Correct (1122)");
        end

        // 2. Test Address 2 (Should match 3rd line: DEAD)
        address = 8'd2;
        #5;
        if (instruction !== 16'hDEAD) begin
            $display("❌ FAIL: Addr 2. Expected DEAD, Got %h", instruction);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Addr 2 Correct (DEAD)");
        end
        
        // 3. Test Address 3 (Should match 4th line: BEEF)
        address = 8'd3;
        #5;
        if (instruction !== 16'hBEEF) begin
            $display("❌ FAIL: Addr 3. Expected BEEF, Got %h", instruction);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Addr 3 Correct (BEEF)");
        end

        // --- Final Report ---
        if (errors > 0) begin
            $display("\n🔴 FAILED: Found %0d errors.", errors);
            $finish(1);
        end else begin
            $display("\n🟢 SUCCESS: Instruction Memory works!");
            $finish(0);
        end
    end

endmodule