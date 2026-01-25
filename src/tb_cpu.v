// File: tb/tb_cpu.v
`timescale 1ns/1ns

module tb_cpu;

    // 1. Declare signals
    reg clk;
    reg reset;
    reg [7:0] a;
    reg [7:0] b;
    reg opcode;
    wire [7:0] out;

    // 2. Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .operand_a(a),
        .operand_b(b),
        .opcode(opcode),
        .result(out)
    );

    // 3. Generate Clock (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 4. The Test Logic
    initial begin
        // --- Setup Monitor (Optional: prints changes to terminal) ---
        $monitor("Time=%0t | Op=%b | A=%d | B=%d | Out=%d", $time, opcode, a, b, out);

        // --- TEST CASE 1: RESET ---
        reset = 1;
        a = 0; b = 0; opcode = 0;
        #10;
        reset = 0;

        // --- TEST CASE 2: ADDITION (10 + 20) ---
        a = 10;
        b = 20;
        opcode = 0; // ADD
        #10; // Wait for clock edge

        // --- THE CHECKER (The "Judge") ---
        if (out !== 30) begin
            $display("\n-------------------------------------------------");
            $display("❌ FAILED: 10 + 20 should be 30, but got %d", out);
            $display("-------------------------------------------------\n");
            $finish(1); // <--- ERROR CODE 1 (Fails the GitHub Action)
        end else begin
            $display("\n-------------------------------------------------");
            $display("✅ PASSED: 10 + 20 = 30");
            $display("-------------------------------------------------\n");
        end

        $finish(0); // <--- EXIT CODE 0 (Passes the GitHub Action)
    end

endmodule