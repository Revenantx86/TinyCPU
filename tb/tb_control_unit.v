// File: tb/tb_control_unit.v
`timescale 1ns/1ns

module tb_control_unit;

    // --- Signals ---
    reg  [15:0] instruction;
    wire [2:0]  alu_op;
    wire        reg_we;
    wire [2:0]  reg_w_addr;
    wire [2:0]  reg_r_addr_a;
    wire [2:0]  reg_r_addr_b;
    wire [7:0]  imm_val;
    wire        imm_sel;
    wire        jump_en;

    integer errors = 0;

    // --- Instantiate the DUT ---
    control_unit uut (
        .instruction(instruction),
        .alu_op(alu_op),
        .reg_we(reg_we),
        .reg_w_addr(reg_w_addr),
        .reg_r_addr_a(reg_r_addr_a),
        .reg_r_addr_b(reg_r_addr_b),
        .imm_val(imm_val),
        .imm_sel(imm_sel),
        .jump_en(jump_en)
    );

    // --- Main Test ---
    initial begin
        $display("\n--- Starting Control Unit Verification ---");

        // 1. Test ADD Instruction (Opcode 0)
        // Format: Op=0(0000), Dest=1(001), SrcA=2(010), SrcB=3(011), Unused=0
        // Hex: 0000_0010_1001_1000 -> 0x0298
        instruction = 16'h0298;
        #10;
        if (reg_we !== 1 || alu_op !== 3'b000 || imm_sel !== 0 || reg_w_addr !== 1) begin
            $display("❌ FAIL: ADD instruction decoding incorrect.");
            errors = errors + 1;
        end else begin
            $display("✅ PASS: ADD decoded correctly (WE=1, ALU_OP=0)");
        end

        // 2. Test LI (Load Immediate) Instruction (Opcode 8)
        // Format: Op=8(1000), Dest=5(101), Imm=0xFF(11111111)
        // Hex: 1000_1011_1111_1111 -> 0x8BFF
        instruction = 16'h8BFF;
        #10;
        if (reg_we !== 1 || imm_sel !== 1 || imm_val !== 8'hFF || reg_w_addr !== 5) begin
             $display("❌ FAIL: LI instruction decoding incorrect.");
             errors = errors + 1;
        end else begin
             $display("✅ PASS: LI decoded correctly (WE=1, IMM_SEL=1, VAL=FF)");
        end

        // 3. Test JMP (Jump) Instruction (Opcode 9)
        // Format: Op=9(1001), Dest=X(000), Imm=0xAA(10101010)
        // Hex: 1001_0001_0101_0101 -> 0x90AA (Dest/Src don't matter)
        instruction = 16'h90AA;
        #10;
        if (jump_en !== 1 || reg_we !== 0 || imm_val !== 8'hAA) begin
            $display("❌ FAIL: JMP instruction decoding incorrect.");
            errors = errors + 1;
        end else begin
            $display("✅ PASS: JMP decoded correctly (JUMP_EN=1, Target=AA)");
        end
        
        // 4. Test Wiring Checks (SrcA / SrcB extraction)
        // Inst: 0x0000 (Op=0, Dest=0, SrcA=0, SrcB=0)
        instruction = 16'hFFFF; 
        // 1111 (Op F - NOP), 111 (Dest), 111 (SrcA), 111 (SrcB)
        #10;
        if (reg_r_addr_a !== 3'b111 || reg_r_addr_b !== 3'b111) begin
             $display("❌ FAIL: Register Address extraction incorrect.");
             errors = errors + 1;
        end else begin
             $display("✅ PASS: Register Address wires are correct");
        end


        // --- Final Report ---
        if (errors > 0) begin
            $display("\n🔴 FAILED: Found %0d errors.", errors);
            $finish(1);
        end else begin
            $display("\n🟢 SUCCESS: Control Unit passed!");
            $finish(0);
        end
    end

endmodule