module regfile (
    input  logic       clk,
    input  logic       RegWrite,
    input  logic [2:0] ra1,
    input  logic [2:0] ra2,
    input  logic [2:0] wa,
    input  logic [7:0] wd,
    output logic [7:0] rd1,
    output logic [7:0] rd2
);

    logic [7:0] rf [7:0];

    always_ff @(posedge clk) begin
        if (RegWrite && wa != 3'b000) begin
            rf[wa] <= wd;
        end
    end

    assign rd1 = (ra1 != 0) ? rf[ra1] : 8'b0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 8'b0;

endmodule
