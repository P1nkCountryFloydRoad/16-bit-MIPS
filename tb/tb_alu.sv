module tb_alu;

    logic [7:0] a, b, result;
    logic [2:0] alu_control;
    logic       zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    task automatic check;
        input [7:0]  exp_result;
        input        exp_zero;
        input integer test_num;
        input [2:0]   op_code;
        begin
            #1;
            if (result !== exp_result || zero !== exp_zero) begin
                $display("FAIL test %0d (alu_control=%03b): a=%0d b=%0d | got result=%0d zero=%0b | expected result=%0d zero=%0b",
                         test_num, op_code, $signed(a), $signed(b),
                         $signed(result), zero,
                         $signed(exp_result), exp_zero);
            end else begin
                $display("PASS test %0d (alu_control=%03b): a=%0d b=%0d => result=%0d zero=%0b",
                         test_num, op_code, $signed(a), $signed(b),
                         $signed(result), zero);
            end
        end
    endtask

    initial begin
        // Test 1: AND
        a = 8'hF0; b = 8'hAA; alu_control = 3'b000;
        check(8'hA0, 1'b0, 1, 3'b000);

        // Test 2: OR
        a = 8'hF0; b = 8'h0F; alu_control = 3'b001;
        check(8'hFF, 1'b0, 2, 3'b001);

        // Test 3: ADD normal
        a = 8'd10; b = 8'd20; alu_control = 3'b010;
        check(8'd30, 1'b0, 3, 3'b010);

        // Test 4: ADD producing zero (5 + (-5))
        a = 8'd5; b = 8'hFB; alu_control = 3'b010;   // 0xFB = -5 in two's complement
        check(8'h00, 1'b1, 4, 3'b010);

        // Test 5: SUB
        a = 8'd15; b = 8'd6; alu_control = 3'b110;
        check(8'd9, 1'b0, 5, 3'b110);

        // Test 6: SLT positive: 3 < 7 => 1
        a = 8'd3; b = 8'd7; alu_control = 3'b111;
        check(8'h01, 1'b0, 6, 3'b111);

        // Test 7: SLT false: 7 < 3 => 0
        a = 8'd7; b = 8'd3; alu_control = 3'b111;
        check(8'h00, 1'b1, 7, 3'b111);

        // Test 8: SLT with negative number: -1 (0xFF) < 1 => 1  (signed comparison)
        a = 8'hFF; b = 8'h01; alu_control = 3'b111;
        check(8'h01, 1'b0, 8, 3'b111);

        // Test 9: SLT equal: 5 < 5 => 0
        a = 8'd5; b = 8'd5; alu_control = 3'b111;
        check(8'h00, 1'b1, 9, 3'b111);

        // Test 10: AND producing zero
        a = 8'hF0; b = 8'h0F; alu_control = 3'b000;
        check(8'h00, 1'b1, 10, 3'b000);

        $finish;
    end

endmodule
