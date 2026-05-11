module tb_mux2;

    // 8-bit instance (data path mux)
    logic [7:0] d0_8, d1_8, y_8;
    logic       s_8;

    mux2 #(.WIDTH(8)) mux_8 (
        .d0(d0_8), .d1(d1_8), .s(s_8), .y(y_8)
    );

    // 3-bit instance (register address mux)
    logic [2:0] d0_3, d1_3, y_3;
    logic       s_3;

    mux2 #(.WIDTH(3)) mux_3 (
        .d0(d0_3), .d1(d1_3), .s(s_3), .y(y_3)
    );

    task automatic check8;
        input [7:0]  exp_y;
        input integer test_num;
        begin
            #1;
            if (y_8 !== exp_y)
                $display("FAIL test %0d (8-bit): s=%0b d0=0x%02X d1=0x%02X | got y=0x%02X | expected y=0x%02X",
                         test_num, s_8, d0_8, d1_8, y_8, exp_y);
            else
                $display("PASS test %0d (8-bit): s=%0b => y=0x%02X",
                         test_num, s_8, y_8);
        end
    endtask

    task automatic check3;
        input [2:0]  exp_y;
        input integer test_num;
        begin
            #1;
            if (y_3 !== exp_y)
                $display("FAIL test %0d (3-bit): s=%0b d0=%0d d1=%0d | got y=%0d | expected y=%0d",
                         test_num, s_3, d0_3, d1_3, y_3, exp_y);
            else
                $display("PASS test %0d (3-bit): s=%0b => y=%0d",
                         test_num, s_3, y_3);
        end
    endtask

    initial begin
        // --- 8-bit mux ---
        // Test 1: s=0 selects d0
        d0_8 = 8'hAB; d1_8 = 8'hCD; s_8 = 1'b0;
        check8(8'hAB, 1);

        // Test 2: s=1 selects d1
        d0_8 = 8'hAB; d1_8 = 8'hCD; s_8 = 1'b1;
        check8(8'hCD, 2);

        // Test 3: s=0 with all-zeros d0
        d0_8 = 8'h00; d1_8 = 8'hFF; s_8 = 1'b0;
        check8(8'h00, 3);

        // Test 4: s=1 with all-ones d1
        d0_8 = 8'h00; d1_8 = 8'hFF; s_8 = 1'b1;
        check8(8'hFF, 4);

        // --- 3-bit mux (register address) ---
        // Test 5: s=0 selects d0
        d0_3 = 3'd2; d1_3 = 3'd5; s_3 = 1'b0;
        check3(3'd2, 5);

        // Test 6: s=1 selects d1
        d0_3 = 3'd2; d1_3 = 3'd5; s_3 = 1'b1;
        check3(3'd5, 6);

        $finish;
    end

endmodule
