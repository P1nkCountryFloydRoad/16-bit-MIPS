module sign_ext_12 (
    input  logic [5:0]  a,
    output logic [11:0] y
);

    assign y = {{6{a[5]}}, a};

endmodule