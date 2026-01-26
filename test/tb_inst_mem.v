// File: tb/tb_inst_mem.v
`timescale 1ns/1ns

module tb_inst_mem;

    // --- Signals ---
    reg  [7:0] address;
    wire [15:0] instruction;
    integer errors = 0;
    integer f; // File handler

    // --- Instantiate the DUT ---
    inst_mem uut (
        .address(address),
        .instruction(instruction)
    );

    // --- Test Setup: Create a Dummy Program ---
    // We create "program.hex" BEFORE the simulation starts using system tasks
    initial begin
        f = $fopen("program.hex", "w");
        // Address 0: 0x1122
        $fwrite(f, "1122\n"); 
        // Address 1: 0x3344
        $fwrite(f, "3344\n");
        // Address 2: 0xDEAD
        $fwrite(f, "DEAD\n");
        // Address 3: 0xBEEF
        $fwrite(f, "BEEF\n");
        $fclose(f);
    end

    // --- Main Test ---
    initial begin
        $display("\n--- Starting Instruction Memory Verification ---");
        
        // Wait a tiny bit for the $readmemh inside the DUT to happen
        #10;

        // 1. Test Address 0
        address = 8'd0;
        #5;
        if (instruction !== 16'h1122) begin
            $display("❌ FAIL: Addr 0. Expected 1122, Got %h", instruction);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Addr 0 Correct (1122)");
        end

        // 2. Test Address 2 (Jump ahead)
        address = 8'd2;
        #5;
        if (instruction !== 16'hDEAD) begin
            $display("❌ FAIL: Addr 2. Expected DEAD, Got %h", instruction);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Addr 2 Correct (DEAD)");
        end
        
        // 3. Test Address 3
        address = 8'd3;
        #5;
        if (instruction !== 16'hBEEF) begin
            $display("❌ FAIL: Addr 3. Expected BEEF, Got %h", instruction);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Addr 3 Correct (BEEF)");
        end

        // 4. Test Uninitialized Address (Should be X or 0 depending on simulator, usually x)
        // We won't strictly fail on this, but it's good to observe.
        address = 8'd10;
        #5;
        $display("ℹ️  Info: Addr 10 (Uninitialized) reads: %h", instruction);


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