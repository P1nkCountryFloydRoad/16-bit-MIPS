module tb_sign_ext;

    logic [5:0] a;
    logic [7:0] y;

    sign_ext dut (.a(a), .y(y));

    task automatic check;
        input [7:0]  exp_y;
        input integer test_num;
        begin
            #1;
            if (y !== exp_y)
                $display("FAIL test %0d: a=6'b%06b | got y=8'b%08b | expected y=8'b%08b",
                         test_num, a, y, exp_y);
            else
                $display("PASS test %0d: a=6'b%06b => y=8'b%08b (%0d)",
                         test_num, a, y, $signed(y));
        end
    endtask

    initial begin
        // Test 1: positive small — +10
        a = 6'b001010;
        check(8'b00001010, 1);

        // Test 2: negative small — -2 in 6-bit
        a = 6'b111110;
        check(8'b11111110, 2);

        // Test 3: largest positive — +31
        a = 6'b011111;
        check(8'b00011111, 3);

        // Test 4: largest negative — -32 in 6-bit
        a = 6'b100000;
        check(8'b11100000, 4);

        // Test 5: zero
        a = 6'b000000;
        check(8'b00000000, 5);

        $finish;
    end

endmodule
