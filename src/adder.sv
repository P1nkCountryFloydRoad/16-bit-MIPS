module adder #(
    parameter WIDTH = 12
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] y
);

    assign y = a + b;

endmodule
