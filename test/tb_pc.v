// File: tb/tb_pc.v
`timescale 1ns/1ns

module tb_pc;

    // --- Signals ---
    reg        clk;
    reg        reset;
    reg        jump_en;
    reg  [7:0] jump_addr;
    wire [7:0] pc_out;

    integer errors = 0;

    // --- Instantiate the DUT ---
    pc uut (
        .clk(clk),
        .reset(reset),
        .jump_en(jump_en),
        .jump_addr(jump_addr),
        .pc_out(pc_out)
    );

    // --- Clock Generation ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- Main Test ---
    initial begin
        $display("\n--- Starting Program Counter Verification ---");

        // 1. Initialization
        reset = 1; jump_en = 0; jump_addr = 0;
        @(posedge clk);
        #1;
        reset = 0;

        // 2. Test: Reset Check
        if (pc_out !== 0) begin
            $display("❌ FAIL: Reset did not set PC to 0. Got: %d", pc_out);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Reset sets PC to 0");
        end

        // 3. Test: Normal Counting (0 -> 1 -> 2 -> 3)
        // Wait 3 clock cycles
        repeat (3) @(posedge clk);
        #1; 
        
        // After 3 cycles (and starting at 0), PC should be 3
        if (pc_out !== 3) begin
            $display("❌ FAIL: PC did not count correctly. Expected 3, got %d", pc_out);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: PC counts up correctly (0 -> 3)");
        end

        // 4. Test: JUMP Operation
        // We are at 3. Let's Jump to 50.
        @(posedge clk); // Sync
        jump_en = 1;
        jump_addr = 8'd50;
        @(posedge clk); // Clock edge happens here, PC should become 50
        jump_en = 0;    // Turn off jump immediately after
        #1;

        if (pc_out !== 50) begin
            $display("❌ FAIL: Jump failed. Expected 50, got %d", pc_out);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Jump to 50 successful");
        end

        // 5. Test: Resume Counting
        // PC was 50. Next cycle it should be 51.
        @(posedge clk); 
        #1;
        if (pc_out !== 51) begin
             $display("❌ FAIL: PC did not resume counting after jump. Expected 51, got %d", pc_out);
             errors = errors + 1;
        end else begin
             $display("✅ PASS: Resumed counting after jump (50 -> 51)");
        end
        
        // 6. Test: Overflow (Wrap Around)
        // Force jump to 255 (Max 8-bit value)
        @(posedge clk);
        jump_en = 1; jump_addr = 8'd255;
        @(posedge clk);
        jump_en = 0;
        
        // Now let it count up. 255 + 1 should wrap to 0.
        @(posedge clk);
        #1;
        if (pc_out !== 0) begin
            $display("❌ FAIL: Overflow check failed. 255 + 1 should be 0, got %d", pc_out);
            errors = errors + 1;
        end else begin
            $display("✅ PASS: Overflow (255 -> 0) works");
        end


        // --- Final Report ---
        if (errors > 0) begin
            $display("\n🔴 FAILED: Found %0d errors.", errors);
            $finish(1);
        end else begin
            $display("\n🟢 SUCCESS: PC passed all tests!");
            $finish(0);
        end
    end

endmodule