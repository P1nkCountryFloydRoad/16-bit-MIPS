module pc (
    input  logic        clk,
    input  logic        reset,
    input  logic [11:0] pc_next,
    output logic [11:0] pc_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 12'd0;
        else
            pc_out <= pc_next;
    end

endmodule
