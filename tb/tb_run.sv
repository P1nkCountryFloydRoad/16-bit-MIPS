// tb_run.sv - Run memfile.dat and dump state after N cycles
// Usage: make run CYCLES=50  (default 50 cycles)

module tb_run;

    parameter CYCLES = 120;

    logic        clk, reset;
    logic [15:0] instr_debug;
    logic [11:0] pc_debug;

    cpu dut (
        .clk(clk), .reset(reset),
        .instr_debug(instr_debug),
        .pc_debug(pc_debug)
    );

    always #5 clk = ~clk;

    integer i;

    initial begin
        $dumpfile("run.vcd");
        $dumpvars(0, tb_run);
        clk = 0; reset = 1;
        @(posedge clk); @(posedge clk); #1;
        reset = 0;

        // Run for CYCLES cycles, print PC + instruction each cycle
        $display("cycle  PC    instr");
        repeat (CYCLES) begin
            @(posedge clk); #1;
            $display("  %3d  0x%03X  %016b", $time/10, pc_debug, instr_debug);
        end

        // Dump register file
        $display("\n--- Registers ---");
        for (i = 0; i < 8; i = i + 1)
            $display("  $%0d = %0d (0x%02X)", i, dut.dp.rf0.rf[i], dut.dp.rf0.rf[i]);

        // Dump first 16 bytes of data memory
        $display("\n--- Data Memory [0:15] ---");
        for (i = 0; i < 16; i = i + 1)
            $display("  mem[%2d] = %0d (0x%02X)", i, dut.dp.dmem0.RAM[i], dut.dp.dmem0.RAM[i]);

        $finish;
    end

endmodule
