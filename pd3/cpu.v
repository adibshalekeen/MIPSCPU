`include "mem.v"
//stage components
`include "decoder.v"
`include "register_file.v"
//sub componenets
`include "register.v"
`include "221_mux.v"
module CPU #(parameter PC_BASE_ADDR = 32'h80020000);

//PC signals
reg [31:0] PC = PC_BASE_ADDR;

//instruction memory signals
reg [31:0] instr_mem_addr, instr_mem_data_in;
wire [31:0] instr_mem_data_out;
reg instr_mem_rw, instr_mem_enable = 1;

wire [31:0] r_instr_reg_out_32;
wire [31:0] w_instr_mem_reg_out;

//decoder signals
wire w_alu_op;
wire w_mem_op;
wire w_branch_op;
wire w_nop;
wire [15:0] w_alu_imm_16;
wire [25:0] w_mem_imm_26;
wire [5:0] w_op_type_6;
wire [4:0] w_rs_5;
wire [4:0] w_rt_5;
wire [4:0] w_rd_5;
wire [4:0] w_sh_5;
wire [5:0] w_func_6;
wire [31:0] w_decoder_instr_out_32;

//registered decoder output
wire r_dalu_op;
wire r_dmem_op;
wire r_dbranch_op;
wire r_dnop;
wire [5:0] r_dop_type_6;
wire [4:0] r_drs_5;
wire [4:0] r_drt_5;
wire [4:0] r_drd_5;
wire [4:0] r_dsh_5;
wire [5:0] r_dfunc_6;
wire [15:0] r_dalu_imm_16;
wire [25:0] r_dmem_imm_26;
wire [31:0] r_ddecoder_instr_out_32;

//registered execution output + ctrl signal registers after register file stage
wire r_ealu_op;
wire r_emem_op;
wire r_ebranch_op;
wire r_enop;
wire [5:0] r_eop_type_6;
wire [4:0] r_ers_5;
wire [4:0] r_ert_5;
wire [4:0] r_erd_5;
wire [4:0] r_esh_5;
wire [5:0] r_efunc_6;
wire [15:0] r_ealu_imm_16;
wire [25:0] r_emem_imm_26;
wire [31:0] r_exec_instr_out_32;

//register file signals
wire [4:0] w_reg_file_addr1_5, w_reg_file_addr2_5, w_reg_file_daddr_5;
wire [31:0] w_reg_file_dval_32, w_reg_file_dout1_32, w_reg_file_dout2_32;
wire w_reg_file_rw;

//test_bench vars
reg [31:0] read_instrs [1000 : 0];
reg [31:0] w_tb_reg_file_d_32;
reg [4:0] w_tb_reg_file_daddr_5;
integer counter = 0;
reg writing = 1;
reg clock = 1;

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, clock);
    $dumpvars(0, PC);
    $dumpvars(0, r_instr_reg_out_32);
    $dumpvars(0, instr_mem_rw);
    $dumpvars(0, r_alu_op);
    $dumpvars(0, r_mem_op);
    $dumpvars(0, r_branch_op);
    $dumpvars(0, r_nop);
    $dumpvars(0, r_op_type_6);
    $dumpvars(0, r_decoder_instr_out_32);
    $dumpvars(0, r_rs_5);
    $dumpvars(0, r_rt_5);
    $dumpvars(0, r_rd_5);
    $dumpvars(0, r_sh_5);
    $dumpvars(0, r_func_6);
    $dumpvars(0, r_alu_imm_16);
    $dumpvars(0, r_mem_imm_26);

    $readmemh("mips-benchmarks/add.x", read_instrs);
    PC = PC_BASE_ADDR;
    instr_mem_rw = 0;
    instr_mem_enable = 1;
    #1000 $finish;
end

mem instruction_memory(.w_data_in_32(instr_mem_data_in),
.w_data_out_32(instr_mem_data_out),
.w_addr_32(instr_mem_addr),
.rw(instr_mem_rw),
.en(instr_mem_enable),
.clock(clock));

decoder instruction_decoder(
.w_instr_32(r_instr_reg_out_32),
.w_instr_out_32(w_decoder_instr_out_32),
.w_alu_op(w_alu_op),
.w_mem_op(w_mem_op),
.w_branch_op(w_branch_op),
.w_nop(w_nop),
.w_alu_imm_val_16(w_alu_imm_16),
.w_branch_imm_val_26(w_mem_imm_26),
.w_op_type_6(w_op_type_6),
.w_rs_addr_5(w_rs_5),
.w_rt_addr_5(w_rt_5),
.w_rd_addr_5(w_rd_5),
.w_sh_amt_5(w_sh_5),
.w_func_6(w_func_6));

register_file reg_file(
    .clock(clock),
    w_address_s1_5(w_reg_file_addr1_5),
    w_address_s2_5(w_reg_file_addr2_5),
    w_address_d_5(w_reg_file_daddr_5),
    w_data_dval_32(w_reg_file_dval_32),
    w_data_s1val_32(w_reg_file_dout1_32),
    w_data_s2val_32(w_reg_file_dout2_32),
    w_write_enable(w_reg_file_rw)
);

register_sync #(32) instr_reg_32 (.clock(clock), .reset(instr_reg_reset), .w_in(instr_mem_data_out), .w_out(r_instr_reg_out_32));

//registering output of decoder
//op type
register_sync #(1) dalu_op_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(w_alu_op), .w_out(r_dalu_op));
register_sync #(1) dmem_op_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(w_mem_op), .w_out(r_dmem_op));
register_sync #(1) dbranch_op_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(w_branch_op), .w_out(r_dbranch_op));
register_sync #(1) dnop_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(w_nop), .w_out(r_nop));
//op code
register_sync #(6) dop_code_reg_6 (.clock(clock), .reset(instr_reg_reset), .w_in(w_op_type_6), .w_out(r_dop_type_6));
//reg params
register_sync #(5) drs_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(w_rs_5), .w_out(r_drs_5));
register_sync #(5) drt_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(w_rt_5), .w_out(r_drt_5));
register_sync #(5) drd_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(w_rd_5), .w_out(r_drd_5));
register_sync #(5) dsh_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(w_sh_5), .w_out(r_dsh_5));
register_sync #(6) dfunc_code_reg_6 (.clock(clock), .reset(instr_reg_reset), .w_in(w_func_6), .w_out(r_dfunc_6));
//imms
register_sync #(16) dalu_imm_reg_16 (.clock(clock), .reset(instr_reg_reset), .w_in(w_alu_imm_16), .w_out(r_dalu_imm_16));
register_sync #(26) dmem_imm_reg_26 (.clock(clock), .reset(instr_reg_reset), .w_in(w_mem_imm_26), .w_out(r_dmem_imm_26));
//raw instr (for debugging)
register_sync #(32) ddecoder_instr_output(.clock(clock), .reset(instr_reg_reset), .w_in(w_decoder_instr_out_32), .w_out(r_decoder_instr_out_32));

//registering output of execution and control signals
//registering control signals
//op type
register_sync #(1) ealu_op_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dalu_op), .w_out(r_ealu_op));
register_sync #(1) emem_op_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dmem_op), .w_out(r_emem_op));
register_sync #(1) ebranch_op_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dbranch_op), .w_out(r_ebranch_op));
register_sync #(1) enop_reg_1 (.clock(clock), .reset(instr_reg_reset), .w_in(w_nop), .w_out(r_nop));
//op code
register_sync #(6) eop_code_reg_6 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dop_type_6), .w_out(r_eop_type_6));
//reg params
register_sync #(5) ers_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(r_drs_5), .w_out(r_ers_5));
register_sync #(5) ert_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(r_drt_5), .w_out(r_ert_5));
register_sync #(5) erd_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(r_drd_5), .w_out(r_erd_5));
register_sync #(5) esh_reg_5 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dsh_5), .w_out(r_esh_5));
register_sync #(6) efunc_code_reg_6 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dfunc_6), .w_out(r_efunc_6));
//imms
register_sync #(16) ealu_imm_reg_16 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dalu_imm_16), .w_out(r_ealu_imm_16));
register_sync #(26) emem_imm_reg_26 (.clock(clock), .reset(instr_reg_reset), .w_in(r_dmem_imm_26), .w_out(r_emem_imm_26));
//raw instr (for debugging)
register_sync #(32) edecoder_instr_output(.clock(clock), .reset(instr_reg_reset), .w_in(r_decoder_instr_out_32), .w_out(r_exec_instr_out_32));

//decoder -> regfile wiring
assign w_reg_file_addr1_5 = r_rs_5;
assign w_reg_file_addr2_5 = r_rt_5;
//for now control this manually through tb since it needs to be muxed via writeback


//memory population loop
always @(posedge clock) begin
    if(~(read_instrs[counter] === 32'bx))
    begin
        if(~instr_mem_rw)
        begin
#1          instr_mem_addr = PC - 32'h80020000;
            PC = PC + 4;
            instr_mem_data_in = read_instrs[counter];
            counter = counter + 1;
            $display("PC: %h, Mem_addr: %h, Data_in: %h, Data_out:%h", PC, instr_mem_addr, instr_mem_data_in, instr_mem_data_out);
        end
    end
    else
        begin
            if(writing)
                begin
                    PC = PC_BASE_ADDR;
                    writing = 0;
                    instr_mem_rw = 1;
                    $display("Resetting... PC:%h", PC);
                end
        end
end

//fetch loop
always @(posedge clock) begin
    if(~writing)
    begin
     #1 instr_mem_addr = PC - 32'h80020000;
        PC = PC + 4;
        $display("PC: %h, Mem_addr: %h, Data_in: %h, Data_out:%h, Reg_out: %h", PC, instr_mem_addr, instr_mem_data_in, instr_mem_data_out, r_instr_reg_out_32);
    end
end

//clock
always begin
    #5 clock = ~clock;
end

endmodule