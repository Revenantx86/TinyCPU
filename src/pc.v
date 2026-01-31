module pc (
    input  wire       clk,
    input  wire       reset,
    input  wire       jump_en,
    input  wire [7:0] jump_addr,
    output reg  [7:0] pc_out
);

    always @(posedge clk) begin 
        if(reset) begin 
            pc_out <= 0;
        end
        else if(jump_en) begin
            pc_out <= jump_addr;
        end
        else begin 
            pc_out <= pc_out + 1;
        end
    end

endmodule
