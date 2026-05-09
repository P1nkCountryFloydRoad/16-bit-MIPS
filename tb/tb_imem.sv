module tb_imem();


    logic [11:0] a;

    logic [15:0] rd;


    imem dut (

        .a(a),

        .rd(rd)

    );


    initial begin

        

        a = 12'd0; 

        #10;

        $display("Address: %0d | Data: %b", a, rd);


        a = 12'd1; 

        #10;

        $display("Address: %0d | Data: %b", a, rd);

        

        a = 12'd2; 

        #10;

        $display("Address: %0d | Data: %b", a, rd);


        $display("Done");

        $finish;

    end


endmodule
