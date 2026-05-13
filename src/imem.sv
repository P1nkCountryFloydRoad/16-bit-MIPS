module imem (
    input  logic [11:0] a,  
    output logic [15:0] rd   
);
    logic [15:0] RAM [0:4095];
    initial begin
        $readmemb("memfile.dat", RAM);
    end
    assign rd = RAM[a];

endmodule
