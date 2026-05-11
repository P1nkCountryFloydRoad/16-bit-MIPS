module sign_ext (
    input  logic [5:0] a,
    output logic [7:0] y
);

    assign y = {{2{a[5]}}, a};

endmodule
