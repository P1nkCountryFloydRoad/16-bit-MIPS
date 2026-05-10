module dmem (
    input  logic       clk,
    input  logic       we,   // Write Enable (MemWrite control signal)
    input  logic [7:0] a,    // 8-bit address
    input  logic [7:0] wd,   // 8-bit write data
    output logic [7:0] rd    // 8-bit read data
);
	logic [7:0] RAM [255:0];
	assign rd = RAM[a];
	always_ff @(posedge clk) begin
        if (we) begin
            RAM[a] <= wd;
        end
    end

endmodule
