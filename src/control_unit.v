module control_unit (
    input  wire [15:0] instruction,
    output reg  [2:0]  alu_op,
    output reg         reg_we,
    output wire [2:0]  reg_w_addr,
    output wire [2:0]  reg_r_addr_a,
    output wire [2:0]  reg_r_addr_b,
    output wire [7:0]  imm_val,
    output reg         imm_sel,
    output reg         jump_en
);

    // Extract fields from instruction
    wire [3:0] opcode = instruction[15:12];
    
    // Wiring specific bits to outputs
    assign reg_w_addr   = instruction[11:9];
    assign reg_r_addr_a = instruction[8:6];
    assign reg_r_addr_b = instruction[5:3];
    assign imm_val      = instruction[7:0]; // Bottom 8 bits

    always @(*) begin
        // Defaults (Safety first)
        reg_we  = 0;
        imm_sel = 0;
        jump_en = 0;
        alu_op  = 3'b000;

        case (opcode)
            // ALU Operations (0-7)
            4'b0000, 4'b0001, 4'b0010, 4'b0011, 
            4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
                reg_we  = 1;          // Write result back
                imm_sel = 0;          // Use ALU result
                jump_en = 0;          // Don't jump
                alu_op  = opcode[2:0]; // Opcode matches ALU op
            end

            // Load Immediate (Opcode 8)
            4'b1000: begin
                reg_we  = 1;  // Write to register
                imm_sel = 1;  // Pick Immediate value
                jump_en = 0;
            end

            // JUMP (Opcode 9)
            4'b1001: begin
                reg_we  = 0;  // Don't write
                jump_en = 1;  // Enable Jump
            end

            // Default / NOP
            default: begin
                reg_we  = 0;
                jump_en = 0;
            end
        endcase
    end

endmodule