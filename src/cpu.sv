module cpu (
    input  logic        clk,
    input  logic        reset,
    output logic [15:0] instr_debug,
    output logic [11:0] pc_debug
);

    // Control
    logic RegDst, ALUSrc, MemtoReg, RegWrite, MemRead;
    logic MemWrite, Branch, Jump, JumpReg;
    logic [2:0] ALUControl;

    // Status 
    logic zero;

    controller ctrl (
        .instruction(instr_debug),
        .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .Branch(Branch), .Jump(Jump), .JumpReg(JumpReg),
        .ALUControl(ALUControl)
    );

    datapath dp (
        .clk(clk), .reset(reset),
        .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),
        .RegWrite(RegWrite), .MemWrite(MemWrite),
        .Branch(Branch), .Jump(Jump), .JumpReg(JumpReg),
        .ALUControl(ALUControl),
        .instruction(instr_debug),
        .zero(zero),
        .pc_out(pc_debug)
    );

endmodule
