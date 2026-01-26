module regfile (
    input  wire       clk,
    input  wire       reset,
    input  wire       we,
    input  wire [2:0] r_addr_a,
    input  wire [2:0] r_addr_b,
    input  wire [2:0] w_addr,
    input  wire [7:0] w_data,
    output wire [7:0] r_data_a,
    output wire [7:0] r_data_b
);

    reg [7:0] registers [0:7];
    integer i;

    // Async Read
    assign r_data_a = registers[r_addr_a];
    assign r_data_b = registers[r_addr_b];

    // Sync Write and Reset
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 8'b0;
            end
        end else if (we) begin
            registers[w_addr] <= w_data;
        end
    end

endmodule