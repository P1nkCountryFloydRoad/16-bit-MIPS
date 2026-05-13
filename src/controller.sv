module controller (
    input  logic [15:0] instruction,
    output logic        RegDst,
    output logic        ALUSrc,
    output logic [1:0]  MemtoReg,
    output logic        RegWrite,
    output logic        MemRead,
    output logic        MemWrite,
    output logic        Branch,
    output logic        Jump,
    output logic        JumpReg,
    output logic        Link,
    output logic [2:0]  ALUControl
);

    logic [3:0] opcode;
    logic [1:0] ALUOp;

    assign opcode = instruction[15:12];

    maindec md (
        .opcode(opcode),
        .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .Branch(Branch), .Jump(Jump), .JumpReg(JumpReg),
        .Link(Link), .ALUOp(ALUOp)
    );

    aludec ad (
        .opcode(opcode),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

endmodule
