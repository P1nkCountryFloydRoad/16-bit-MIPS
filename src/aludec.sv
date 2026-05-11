module aludec (
    input  logic [3:0] opcode,
    input  logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

    always_comb begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010; // ADD 
            2'b01: ALUControl = 3'b110; // SUB 
            2'b10: begin                 // R-type
                case (opcode)
                    4'b0001: ALUControl = 3'b010; // add
                    4'b0010: ALUControl = 3'b110; // sub
                    4'b0011: ALUControl = 3'b000; // and
                    4'b0100: ALUControl = 3'b001; // or
                    4'b0101: ALUControl = 3'b111; // slt
                    default: ALUControl = 3'bxxx;
                endcase
            end
            default: ALUControl = 3'bxxx; 
        endcase
    end

endmodule
