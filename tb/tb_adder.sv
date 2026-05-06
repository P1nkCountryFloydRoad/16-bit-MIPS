module tb_adder;

    logic [11:0] a, b, y;

    adder #(.WIDTH(12)) dut (
        .a(a),
        .b(b),
        .y(y)
    );

    task automatic check;
        input [11:0] exp_y;
        input [63:0] test_num;
        begin
            #1;
            if (y !== exp_y) begin
                $display("FAIL test %0d: a=0x%03X b=0x%03X | got y=0x%03X | expected y=0x%03X",
                         test_num, a, b, y, exp_y);
            end else begin
                $display("PASS test %0d: a=0x%03X + b=0x%03X => y=0x%03X",
                         test_num, a, b, y);
            end
        end
    endtask

    initial begin
        // Test 1: basic PC+1
        a = 12'h000; b = 12'h001;
        check(12'h001, 1);

        // Test 2: typical PC increment
        a = 12'h004; b = 12'h001;
        check(12'h005, 2);

        // Test 3: larger addition
        a = 12'h100; b = 12'h200;
        check(12'h300, 3);

        // Test 4: wraparound at 12-bit boundary (0xFFF + 1 = 0x000)
        a = 12'hFFF; b = 12'h001;
        check(12'h000, 4);

        // Test 5: wraparound mid-range (0xFF0 + 0x020 = 0x010)
        a = 12'hFF0; b = 12'h020;
        check(12'h010, 5);

        // Test 6: both operands zero
        a = 12'h000; b = 12'h000;
        check(12'h000, 6);

        $finish;
    end

endmodule
