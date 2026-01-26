// File: tb/tb_regfile.v
`timescale 1ns/1ns

module tb_regfile;

    // --- Signals ---
    reg        clk;
    reg        reset;
    reg        we;
    reg  [2:0] r_addr_a;
    reg  [2:0] r_addr_b;
    reg  [2:0] w_addr;
    reg  [7:0] w_data;
    wire [7:0] r_data_a;
    wire [7:0] r_data_b;

    integer errors = 0;

    // --- Instantiate the DUT (Device Under Test) ---
    regfile uut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .r_addr_a(r_addr_a),
        .r_addr_b(r_addr_b),
        .w_addr(w_addr),
        .w_data(w_data),
        .r_data_a(r_data_a),
        .r_data_b(r_data_b)
    );

    // --- Clock Generation ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns Clock Period
    end

    // --- Main Test ---
    initial begin
        $display("\n--- Starting Register File Verification ---");

        // 1. Initialize
        reset = 1; we = 0; 
        w_addr = 0; w_data = 0;
        r_addr_a = 0; r_addr_b = 0;
        @(posedge clk);
        #1; // Hold reset for a bit
        reset = 0;

        // 2. Test: Write to Register 1
        // We want to write 0xAA (170) to Register 1
        @(posedge clk); // Sync with clock
        we = 1;
        w_addr = 3'd1;
        w_data = 8'hAA;
        @(posedge clk); // Wait for write to happen
        we = 0;         // Turn off write

        // 3. Test: Read it back on Port A
        r_addr_a = 3'd1;
        #1; // Wait a tiny bit for async read
        if (r_data_a !== 8'hAA) begin
            $display("❌ FAIL: Wrote AA to Reg 1, read back %h", r_data_a);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Write/Read R1 successful");
        end

        // 4. Test: Write Enable Protection
        // Try to write 0xFF to Register 1 BUT keep we = 0.
        // The value should stay 0xAA.
        @(posedge clk);
        we = 0;        // DISABLE WRITE
        w_addr = 3'd1;
        w_data = 8'hFF;
        @(posedge clk);

        r_addr_a = 3'd1;
        #1;
        if (r_data_a !== 8'hAA) begin
            $display("❌ FAIL: Write Enable broken! R1 changed to %h when WE was 0", r_data_a);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Write Enable protection works");
        end

        // 5. Test: Dual Read Ports
        // Write 0x55 to Register 2
        @(posedge clk);
        we = 1;
        w_addr = 3'd2;
        w_data = 8'h55;
        @(posedge clk);
        we = 0;

        // Read R1 on Port A (should be AA) AND R2 on Port B (should be 55) at the same time
        r_addr_a = 3'd1;
        r_addr_b = 3'd2;
        #1;

        if (r_data_a !== 8'hAA || r_data_b !== 8'h55) begin
            $display("❌ FAIL: Dual Port Read failed. A=%h (exp AA), B=%h (exp 55)", r_data_a, r_data_b);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Dual Port Read works");
        end
        
        // 6. Test: Reset Behavior
        // Assert Reset. R1 and R2 should become 0.
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        r_addr_a = 3'd1;
        r_addr_b = 3'd2;
        #1;
        if (r_data_a !== 0 || r_data_b !== 0) begin
             $display("❌ FAIL: Reset did not clear registers. R1=%h, R2=%h", r_data_a, r_data_b);
             errors = errors + 1;
        end else begin
             $display("✅ PASS: Reset works");
        end


        // --- Final Report ---
        if (errors > 0) begin
            $display("\n🔴 FAILED: Found %0d errors.", errors);
            $finish(1);
        end else begin
            $display("\n🟢 SUCCESS: Register File passed all tests!");
            $finish(0);
        end
    end

endmodule