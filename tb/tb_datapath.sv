module tb_datapath();
    // Inputs to DUT
    logic        clk;
    logic        reset;
    logic        RegDst;
    logic        ALUSrc;
    logic        MemtoReg;
    logic        RegWrite;
    logic        MemWrite;
    logic        Branch;
    logic        Jump;
    logic        JumpReg;
    logic [2:0]  ALUControl;


    // Outputs from DUT
    logic [15:0] instruction;
    logic        zero;
    logic [11:0] pc_out;

    datapath dut (
        .clk(clk),
        .reset(reset),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .JumpReg(JumpReg),
        .ALUControl(ALUControl),
        .instruction(instruction),
        .zero(zero),
        .pc_out(pc_out)
	);
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        RegDst = 0;
        ALUSrc = 0;
        MemtoReg = 0;
        RegWrite = 0;
        MemWrite = 0;
        Branch = 0;
        Jump = 0;
        JumpReg = 0;
        ALUControl = 3'b000;
        #10;
        reset = 0;


        // Test Case 1: R-Type ADD (add $1, $2, $3)
        // Format: [15:12]=opcode [11:9]=rs [8:6]=rt [5:3]=rd [2:0]=unused
        // Opcode=0001, rs=2 (010), rt=3 (011), rd=1 (001), unused=000
        dut.imem_array[0] = 16'b0001_010_011_001_000; 
        dut.rf[2] = 8'd10; 
        dut.rf[3] = 8'd15; 
        RegDst   = 1;    
        ALUSrc   = 0;  
        MemtoReg = 0;  
        RegWrite = 1;   
        ALUControl = 3'b010; 
        #10; 
        $display("Test 1 (ADD) : $1 = %0d | Expected: 25", dut.rf[1]);


        // Test Case 2: I-Type ADDI (addi $4, $1, 5)
        // Format: [15:12]=opcode [11:9]=rs [8:6]=rt [5:0]=imm
        // Opcode=0110, rs=1 (001), rt=4 (100), imm=5 (000101)
        dut.imem_array[1] = 16'b0110_001_100_000101; 
        RegWrite = 0;
        #10;
        RegDst   = 0;
        ALUSrc   = 1;
        MemtoReg = 0;
        RegWrite = 1;
        ALUControl = 3'b010;
        #10; 
        $display("Test 2 (ADDI): $4 = %0d | Expected: 30", dut.rf[4]);
        $finish;
    end

endmodule
