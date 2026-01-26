module inst_mem (
    input  wire [7:0]  address,
    output wire [15:0] instruction
);

    reg [15:0] memory [0:255];

    // Initialize memory from file
    initial begin
        // The testbench creates this file.
        // If simulating manually, make sure this file exists.
        $readmemh("program.hex", memory);
    end

    // Async Read
    assign instruction = memory[address];

endmodule