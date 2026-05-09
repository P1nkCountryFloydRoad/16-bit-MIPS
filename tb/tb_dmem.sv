module tb_dmem();


    logic       clk;

    logic       we;

    logic [7:0] a;

    logic [7:0] wd;

    logic [7:0] rd;


    dmem dut (

        .clk(clk),

        .we(we),

        .a(a),

        .wd(wd),

        .rd(rd)

    );


    always #5 clk = ~clk;


    initial begin

        clk = 0;

        we = 0;

        a = 8'd0;

        wd = 8'd0;


        @(negedge clk);

        we = 1;

        a  = 8'h0A;

        wd = 8'hFF;

        

        @(negedge clk);

        we = 0;


        #10;

        a = 8'h0A;

        #5;

        

            $display("Expect FF, got %h from address %h", rd, a);


        a = 8'h0B;

        #5;

        $display("Read %h from uninitialized address %h", rd, a);


        $display("Done");

        $finish;

    end


endmodule
