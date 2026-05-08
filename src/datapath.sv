// Instruction format: [15:12]=opcode [11:9]=rs [8:6]=rt [5:3]=rd [2:0]=funct
// I-type immediate: instruction[5:0]
// J-type target:    instruction[11:0]
module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic        RegDst,
    input  logic        ALUSrc,
    input  logic        MemtoReg,
    input  logic        RegWrite,
    input  logic        MemWrite,
    input  logic        Branch,
    input  logic        Jump,
    input  logic        JumpReg,
    input  logic [2:0]  ALUControl,
    output logic [15:0] instruction,
    output logic        zero
);

    // state
    logic [15:0] imem_array [0:15];  
    logic [7:0]  rf         [0:7];   
    logic [7:0]  dmem_array [0:255]; 

    // PC
    logic [11:0] pc_out;
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
    assign instruction = imem_array[pc_out[3:0]];

    //  Register file 
    logic [2:0] a1, a2, a3;
    logic [7:0] rd1, rd2, wd3;

    assign a1  = instruction[11:9];
    assign a2  = instruction[8:6];
    assign rd1 = rf[a1];
    assign rd2 = rf[a2];

    // RegDst mux: write address = rt (RegDst=0) or rd (RegDst=1)
    mux2 #(.WIDTH(3)) mux_regdst (
        .d0(instruction[8:6]), .d1(instruction[5:3]),
        .s(RegDst), .y(a3)
    );

    // Sign extension
    logic [7:0]  sign_ext_imm;
    logic [11:0] sign_ext_imm_12;

    sign_ext se_8 (
        .a(instruction[5:0]), .y(sign_ext_imm)
    );

    sign_ext_12 se_12 (
        .a(instruction[5:0]), .y(sign_ext_imm_12)
    );

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

    assign mem_read_data = dmem_array[alu_result];

    always_ff @(posedge clk) begin
        if (MemWrite)
            dmem_array[alu_result] <= rd2;
    end

    
    // MemtoReg mux: write data = ALU result (MemtoReg=0) or memory (MemtoReg=1)
    mux2 #(.WIDTH(8)) mux_memtoreg (
        .d0(alu_result), .d1(mem_read_data),
        .s(MemtoReg), .y(wd3)
    );

    // Register file write port
    always_ff @(posedge clk) begin
        if (RegWrite && a3 != 3'b000)
            rf[a3] <= wd3;
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