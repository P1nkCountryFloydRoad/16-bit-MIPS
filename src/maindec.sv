module maindec (
    input  logic [3:0] opcode,
    output logic       RegDst,
    output logic       ALUSrc,
    output logic [1:0] MemtoReg,
    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       Branch,
    output logic       Jump,
    output logic       JumpReg,
    output logic       Link,
    output logic [1:0] ALUOp
);

    always_comb begin
        
        {RegDst, ALUSrc, RegWrite, MemRead, MemWrite,
         Branch, Jump, JumpReg, Link} = 9'b0;
        MemtoReg = 2'b00;
        ALUOp    = 2'b00;

        case (opcode)
            4'b0001: begin RegDst=1; RegWrite=1; ALUOp=2'b10; end // add
            4'b0010: begin RegDst=1; RegWrite=1; ALUOp=2'b10; end // sub
            4'b0011: begin RegDst=1; RegWrite=1; ALUOp=2'b10; end // and
            4'b0100: begin RegDst=1; RegWrite=1; ALUOp=2'b10; end // or
            4'b0101: begin RegDst=1; RegWrite=1; ALUOp=2'b10; end // slt
            4'b0110: begin ALUSrc=1; RegWrite=1;               end // addi
            4'b0111: begin ALUSrc=1; MemtoReg=2'b01; RegWrite=1; MemRead=1; end // lw
            4'b1000: begin ALUSrc=1; MemWrite=1;              end // sw
            4'b1001: begin Branch=1; ALUOp=2'b01;             end // beq
            4'b1010: begin Jump=1;                             end // j
            4'b1011: begin Jump=1; RegWrite=1; MemtoReg=2'b10; Link=1; end // jal
            4'b1100: begin JumpReg=1;                          end // jr
            default: ; 
        endcase
    end

endmodule
