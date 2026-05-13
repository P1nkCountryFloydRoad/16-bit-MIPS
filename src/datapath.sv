// Instruction format: [15:12]=opcode [11:9]=rs [8:6]=rt [5:3]=rd [2:0]=funct
// I-type immediate: instruction[5:0]
// J-type target:    instruction[11:0]
module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic        RegDst,
    input  logic        ALUSrc,
    input  logic [1:0]  MemtoReg,
    input  logic        RegWrite,
    input  logic        MemWrite,
    input  logic        Branch,
    input  logic        Jump,
    input  logic        JumpReg,
    input  logic        Link,
    input  logic [2:0]  ALUControl,
    output logic [15:0] instruction,
    output logic        zero,
    output logic [11:0] pc_out
);

    // state
   
    // PC
    logic [11:0] pc_next;
    logic [11:0] pc_plus_1;
    logic [11:0] pc_branch;
    logic        branch_taken;
    logic [11:0] pc_br_out, pc_j_out;

    pc pc_reg (
        .clk(clk), .reset(reset),
        .pc_next(pc_next), .pc_out(pc_out)
    );

    adder #(.WIDTH(12)) pc_adder (
        .a(pc_out), .b(12'd1), .y(pc_plus_1)
    );

    // IMEM
    imem imem0 (
        .a(pc_out),
        .rd(instruction)
    );

    //  Register file 
    logic [2:0] a3;
    logic [7:0] rd1, rd2, wd3;

    regfile rf0 (
        .clk(clk),
        .RegWrite(RegWrite),
        .ra1(instruction[11:9]),
        .ra2(instruction[8:6]),
        .wa(a3),
        .wd(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // RegDst mux: write address = rt (RegDst=0) or rd (RegDst=1)
    logic [2:0] a3_regdst;
    mux2 #(.WIDTH(3)) mux_regdst (
        .d0(instruction[8:6]), .d1(instruction[5:3]),
        .s(RegDst), .y(a3_regdst)
    );

    // JAL always writes to $7 ($ra)
    assign a3 = Link ? 3'b111 : a3_regdst;

    // Sign extension
    logic [7:0]  sign_ext_imm;
    logic [11:0] sign_ext_imm_12;

    sign_ext se_8 (
        .a(instruction[5:0]), .y(sign_ext_imm)
    );

    sign_ext_12 se_12 (
        .a(instruction[5:0]), .y(sign_ext_imm_12)
    );

    //  JAL return address
    logic [7:0] pc_plus_1_lo;
    assign pc_plus_1_lo = pc_plus_1[7:0];

    // ALU
    logic [7:0] alu_b, alu_result;

    // ALUSrc mux: ALU B = rd2 (ALUSrc=0) or sign-extended imm (ALUSrc=1)
    mux2 #(.WIDTH(8)) mux_alusrc (
        .d0(rd2), .d1(sign_ext_imm),
        .s(ALUSrc), .y(alu_b)
    );

    alu alu0 (
        .a(rd1), .b(alu_b),
        .alu_control(ALUControl),
        .result(alu_result), .zero(zero)
    );

    // Data memory
    logic [7:0] mem_read_data;

    dmem dmem0 (
        .clk(clk),
        .we(MemWrite),
        .a(alu_result),
        .wd(rd2),
        .rd(mem_read_data)
    );

    
    // wd3 source:
    //   2'b00 = ALU result   (R-type, addi, sw)
    //   2'b01 = memory       (lw)
    //   2'b10 = pc_plus_1[7:0]  (JAL: save return address)
    always_comb begin
        case (MemtoReg)
            2'b01:   wd3 = mem_read_data;
            2'b10:   wd3 = pc_plus_1_lo;
            default: wd3 = alu_result;
        endcase
    end

    // PC next selection
    assign branch_taken = Branch & zero;

    logic [11:0] rd1_ext;
    assign rd1_ext = {4'b0000, rd1};  

    adder #(.WIDTH(12)) br_adder (
        .a(pc_plus_1), .b(sign_ext_imm_12), .y(pc_branch)
    );

    mux2 #(.WIDTH(12)) mux_branch (
        .d0(pc_plus_1), .d1(pc_branch),
        .s(branch_taken), .y(pc_br_out)
    );

    mux2 #(.WIDTH(12)) mux_jump (
        .d0(pc_br_out), .d1(instruction[11:0]),
        .s(Jump), .y(pc_j_out)
    );

    mux2 #(.WIDTH(12)) mux_jumpreg (
        .d0(pc_j_out), .d1(rd1_ext),
        .s(JumpReg), .y(pc_next)
    );


endmodule