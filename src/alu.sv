module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [2:0] alu_control,
    output logic [7:0] result,
    output logic       zero
);

    always_comb begin
        case (alu_control)
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b111: result = ($signed(a) < $signed(b)) ? 8'h01 : 8'h00;
            default: result = 8'h00;
        endcase
    end

    assign zero = (result == 8'h00) ? 1'b1 : 1'b0;

endmodule
