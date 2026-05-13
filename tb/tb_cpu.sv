module tb_cpu;

    logic        clk, reset;
    logic [15:0] instr_debug;
    logic [11:0] pc_debug;

    cpu dut (
        .clk(clk), .reset(reset),
        .instr_debug(instr_debug),
        .pc_debug(pc_debug)
    );

    always #5 clk = ~clk;

    integer pass_count, fail_count;

    task automatic chk8;
        input [7:0]  got;
        input [7:0]  expected;
        input integer n;
        input [8*8-1:0] label;
        begin
            if (got === expected) begin
                $display("PASS %2d %0s = %0d", n, label, got);
                pass_count++;
            end else begin
                $display("FAIL %2d %0s = %0d (expected %0d)", n, label, got, expected);
                fail_count++;
            end
        end
    endtask

    task automatic chk12;
        input [11:0] got;
        input [11:0] expected;
        input integer n;
        input [8*8-1:0] label;
        begin
            if (got === expected) begin
                $display("PASS %2d %0s = 0x%03X", n, label, got);
                pass_count++;
            end else begin
                $display("FAIL %2d %0s = 0x%03X (expected 0x%03X)", n, label, got, expected);
                fail_count++;
            end
        end
    endtask

    task automatic clear_all;
        integer i;
        begin
            for (i = 0; i < 4096; i++) dut.dp.imem0.RAM[i] = 16'h1000;
            for (i = 0; i < 8;    i++) dut.dp.rf0.rf[i]    = 8'd0;
            for (i = 0; i < 256;  i++) dut.dp.dmem0.RAM[i] = 8'd0;
        end
    endtask

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_cpu);
        clk = 0; reset = 1;
        pass_count = 0; fail_count = 0;

        // Phase 1: regression
        @(posedge clk); @(posedge clk); #1;
        clear_all();

        dut.dp.imem0.RAM[0]  = 16'h6045; // addi $1,$0,5
        dut.dp.imem0.RAM[1]  = 16'h6083; // addi $2,$0,3
        dut.dp.imem0.RAM[2]  = 16'h1298; // add  $3,$1,$2
        dut.dp.imem0.RAM[3]  = 16'h22A0; // sub  $4,$1,$2
        dut.dp.imem0.RAM[4]  = 16'h32A8; // and  $5,$1,$2
        dut.dp.imem0.RAM[5]  = 16'h42B0; // or   $6,$1,$2
        dut.dp.imem0.RAM[6]  = 16'h5478; // slt  $7,$2,$1
        dut.dp.imem0.RAM[7]  = 16'h804A; // sw   $1,10($0)
        dut.dp.imem0.RAM[8]  = 16'h710A; // lw   $4,10($0)
        dut.dp.imem0.RAM[9]  = 16'h9241; // beq  $1,$1,+1
        dut.dp.imem0.RAM[10] = 16'h6163; // addi $5,$0,35 (skipped)
        dut.dp.imem0.RAM[11] = 16'hA00D; // j 0x00D
        dut.dp.imem0.RAM[12] = 16'h61A3; // addi $6,$0,35 (skipped)
        dut.dp.imem0.RAM[13] = 16'h1000; // nop

        @(negedge clk); reset = 0;
        repeat(12) @(posedge clk); #1;

        chk8(dut.dp.rf0.rf[1],      8'd5, 1, "rf[1]   ");
        chk8(dut.dp.rf0.rf[2],      8'd3, 2, "rf[2]   ");
        chk8(dut.dp.rf0.rf[3],      8'd8, 3, "rf[3]   ");
        chk8(dut.dp.rf0.rf[4],      8'd5, 4, "rf[4]   ");
        chk8(dut.dp.rf0.rf[5],      8'd1, 5, "rf[5]   ");
        chk8(dut.dp.rf0.rf[6],      8'd7, 6, "rf[6]   ");
        chk8(dut.dp.rf0.rf[7],      8'd1, 7, "rf[7]   ");
        chk8(dut.dp.dmem0.RAM[10],  8'd5, 8, "dmem[10]");

        // Phase 2: JAL
        reset = 1;
        @(posedge clk); @(posedge clk); #1;
        clear_all();

        dut.dp.imem0.RAM[0] = 16'hB002; // jal 0x002
        dut.dp.imem0.RAM[1] = 16'h6141; // addi $1,$0,33 (skipped)
        dut.dp.imem0.RAM[2] = 16'h1000; // nop

        @(negedge clk); reset = 0;
        repeat(2) @(posedge clk); #1;

        chk8 (dut.dp.rf0.rf[7], 8'd1,     9, "rf[7]   ");
        chk8 (dut.dp.rf0.rf[1], 8'd0,    10, "rf[1]   ");
        chk12(pc_debug,         12'h003, 11, "pc      ");

        $display("%0d pass, %0d fail", pass_count, fail_count);
        $finish;
    end

endmodule
