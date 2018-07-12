`include "mem.v"
//stage components
`include "decoder.v"
`include "register_file.v"
`include "alu.v"
`include "branch_ctrlr.v"
`include "data_mem.v"
//sub componenets
`include "register.v"
`include "alu_input_ctrlr.v"
`include "hazard_detection_ctrlr.v"
`include "reg_file_waddr_ctrlr.v"
`include "reg_file_wdata_ctrlr.v"
`include "mux_421.v"
`include "mux_221.v"
`include "sgn_extension_unit.v"
module CPU #(parameter PC_BASE_ADDR = 32'h8001FFFC);

//PC signals
reg [31:0] MANUAL_PC = PC_BASE_ADDR;
wire [31:0] PC;
wire [31:0] input_r_PC;
reg manual_addressing = 1;
assign input_r_PC = r_PC;
reg MANUAL_PC_CTRL = 1;
reg [31:0] r_PC;
reg instr_reg_reset = 1;

//instruction memory signals
wire [31:0] instr_mem_addr;
reg [31:0] instr_mem_data_in;
wire [31:0] instr_mem_data_out;
reg instr_mem_rw, instr_mem_enable = 1;

//fetch signals
wire [31:0] r_fpc;
wire [31:0] r_instr_reg_out_32;

//decoder signals
wire w_alu_op;
wire w_unsigned_op;
wire w_imm_op;
wire w_byte_op;
wire w_shift_op;
wire w_mem_op;
wire w_write_op;
wire w_branch_op;
wire w_jump_op;
wire w_nop;
wire [15:0] w_alu_imm_16;
wire [25:0] w_br_imm_26;
wire [5:0] w_op_type_6;
wire [4:0] w_rs_5;
wire [4:0] w_rt_5;
wire [4:0] w_rd_5;
wire [4:0] w_sh_5;
wire [5:0] w_func_6;
wire [31:0] w_decoder_instr_out_32;

//registered decoder output
reg [1:0] decode_stage_ctrl_reg_reset = 2'b01;
wire w_dreg_reset;
wire [31:0] r_dpc;
wire r_dalu_op;
wire r_dunsigned_op;
wire r_dimm_op;
wire r_dbyte_op;
wire r_dshift_op;
wire r_dmem_op;
wire r_dwrite_op;
wire r_dbranch_op;
wire r_djump_op;
wire r_dnop;
wire [5:0] r_dop_type_6;
wire [4:0] r_drs_5;
wire [4:0] r_drt_5;
wire [4:0] r_drd_5;
wire [4:0] r_dsh_5;
wire [5:0] r_dfunc_6;
wire [15:0] r_dalu_imm_16;
wire [25:0] r_dbr_imm_26;
wire [31:0] r_decoder_instr_out_32;

//registered execution output + ctrl signal registers after register file stage
reg execution_stage_ctrl_reg_reset = 1;
wire [31:0] r_epc;
wire r_ealu_op;
wire r_eunsigned_op;
wire r_eimm_op;
wire r_ebyte_op;
wire r_eshift_op;
wire r_emem_op;
wire r_ewrite_op;
wire r_ebranch_op;
wire r_ejump_op;
wire r_enop;
wire [5:0] r_eop_type_6;
wire [4:0] r_ers_5;
wire [4:0] r_ert_5;
wire [4:0] r_erd_5;
wire [4:0] r_esh_5;
wire [25:0] r_ebr_imm_26;
wire [15:0] r_ealu_imm_16;
wire [31:0] r_ealu_out_32;
wire r_ealu_br_condition;
wire [31:0] r_ert_data_32;
wire [31:0] r_exec_instr_out_32;

wire [31:0] r_ealu_imm_sgn_ext_32;

//registered memory stage output
reg memory_stage_ctrl_reg_reset = 1;
wire [31:0] r_mpc;
wire r_malu_op;
wire r_munsigned_op;
wire r_mimm_op;
wire r_mbyte_op;
wire r_mshift_op;
wire r_mmem_op;
wire r_mwrite_op;
wire r_mbranch_op;
wire r_mjump_op;
wire r_mnop;
wire [5:0] r_mop_type_6;
wire [4:0] r_mrs_5;
wire [4:0] r_mrt_5;
wire [4:0] r_mrd_5;
wire [4:0] r_msh_5;
wire [5:0] r_mfunc_6;
wire [15:0] r_malu_imm_16;
wire [25:0] r_mbr_imm_26;
wire [31:0] r_malu_out_32;
wire [31:0] r_mrt_data_32;
wire [31:0] r_mdmem_data_32;
wire [7:0] r_mdmem_data_8;
wire [31:0] r_mem_instr_out_32;

//register file signals
wire [4:0] w_reg_file_daddr_5;
wire [31:0] w_reg_file_dval_32, w_reg_file_dout1_32, w_reg_file_dout2_32;
wire w_reg_file_wen;

//alu signals
wire [31:0] w_alu_rhs_32, w_alu_lhs_32, w_alu_imm_32, w_alu_out_32, w_dalu_imm_signextended_32, w_rs_bypass_mux_32, w_rt_bypass_mux_32;
wire w_alu_br_condition;
wire alu_lhs_ctrl;
wire [1:0] alu_rhs_ctrl;

//data memory signals
wire [31:0] w_dmem_data_in_32, w_dmem_data_out_32, w_dmem_data_addr_32;
wire [7:0] w_dmem_data_out_8;

//write back signals
wire w_reg_file_waddr_ctrl;
wire [1:0] w_reg_file_wdata_ctrl;
wire [31:0] w_sgn_ext_mdmem_data_8;

//bypass controller signals
wire w_stall, w_stall1;
wire w_wm_rt_bypass, w_we_rs_bypass, w_we_rt_bypass, w_me_rs_bypass, w_me_rt_bypass;
wire [31:0] w_stalled_pc;

//branch controller signals
wire [31:0] w_advanced_pc_32;

//test_bench vars
reg [31:0] read_instrs [10000 : 0];
wire [1:0] instr_mem_addr_mux_ctrl;
integer counter = 0;
reg writing = 1;
reg clock = 1;

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, alu);
    $dumpvars(0, alu_in_ctrl);
    $dumpvars(0, alu_imm);
    $dumpvars(0, alu_rs_rt_sh_imm_mux);
    $dumpvars(0, alu_rs_rt_mux);
    $dumpvars(0, instruction_decoder);
    $dumpvars(0, branch_ctrl);
    $dumpvars(0, reg_file);
    $dumpvars(0, reg_file_waddr_rd_rt);
    $dumpvars(0, reg_file_wdata_mem_imm);
    $dumpvars(0, wb_in_sgn_ext_unit);
    $dumpvars(1, d_mem);
    $dumpvars(0, dmem_ert_wb_mux);
    $dumpvars(0, hazard_detector);
    $dumpvars(0, instruction_decoder);
    $dumpvars(0, wb_wadder_ctrlr);
    $dumpvars(0, wb_wdata_ctrlr);
    $dumpvars(0, alu_rfrs_mrs_ers_bypass_mux);
    $dumpvars(0, alu_rfrt_mrt_ert_bypass_mux);
    $dumpvars(0, stall_generator);
    $dumpvars(0, branch_ctrl);
    $dumpvars (0, instr_mem_input_mux);
    $dumpvars (0, instruction_memory);
    $dumpvars(0, dpc_reg_32);
    $dumpvars(1, CPU);
    $readmemh("mips-benchmarks/Fibonacci.x", read_instrs);
    instr_mem_rw = 0;
    #10000 $finish;
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
.w_unsigned_op(w_unsigned_op),
.w_imm_op(w_imm_op),
.w_byte_op(w_byte_op),
.w_shift_op(w_shift_op),
.w_mem_op(w_mem_op),
.w_write_op(w_write_op),
.w_branch_op(w_branch_op),
.w_jump_op(w_jump_op),
.w_nop(w_nop),
.w_alu_imm_val_16(w_alu_imm_16),
.w_branch_imm_val_26(w_br_imm_26),
.w_op_type_6(w_op_type_6),
.w_rs_addr_5(w_rs_5),
.w_rt_addr_5(w_rt_5),
.w_rd_addr_5(w_rd_5),
.w_sh_amt_5(w_sh_5),
.w_func_6(w_func_6));

register_file reg_file(
.clock(clock),
.w_address_s1_5(r_drs_5),
.w_address_s2_5(r_drt_5),
.w_address_d_5(w_reg_file_daddr_5),
.w_data_dval_32(w_reg_file_dval_32),
.w_data_s1val_32(w_reg_file_dout1_32),
.w_data_s2val_32(w_reg_file_dout2_32),
.w_en(w_reg_file_wen)
);

ALU #(32) alu (
.w_op_code_6(r_dop_type_6),
.w_mem_op(r_dmem_op),
.w_branch_op(r_dbranch_op),
.w_input1_x(w_alu_lhs_32),
.w_input2_x(w_alu_rhs_32),
.w_output_x(w_alu_out_32),
.w_output_condition(w_alu_br_condition)
);

data_mem d_mem(
    .w_data_in_32(w_dmem_data_in_32),
    .w_addr_32(r_ealu_out_32),
    .w_write_op(r_ewrite_op),
    .w_byte_op(r_ebyte_op),
    .w_en(r_emem_op),
    .clock(clock),
    .w_data_out_32(w_dmem_data_out_32),
    .w_data_out_8(w_dmem_data_out_8)
);

hazard_detection_ctrlr hazard_detector(
    .clock(clock),
    .w_mem_op(w_mem_op),
    .w_write_op(w_write_op),
    .w_rs_addr_5(w_rs_5),
    .w_rt_addr_5(w_rt_5),
    .w_dalu_op(r_dalu_op),
    .w_dimm_op(r_dimm_op),
    .w_dmem_op(r_dmem_op),
    .w_dwrite_op(r_dwrite_op),
    .w_drs_addr_5(r_drs_5),
    .w_drt_addr_5(r_drt_5),
    .w_drd_addr_5(r_drd_5),
    .w_ealu_op(r_ealu_op),
    .w_eimm_op(r_eimm_op),
    .w_emem_op(r_emem_op),
    .w_ewrite_op(r_ewrite_op),
    .w_ers_addr_5(r_ers_5),
    .w_ert_addr_5(r_ert_5),
    .w_erd_addr_5(r_erd_5),
    .w_malu_op(r_malu_op),
    .w_mimm_op(r_mimm_op),
    .w_mmem_op(r_mmem_op),
    .w_mwrite_op(r_mwrite_op),
    .w_wb_regfile_addr_5(w_reg_file_daddr_5),
    .w_stall(w_stall),
    .w_wm_rt_bypass(w_wm_rt_bypass),
    .w_we_rs_bypass(w_we_rs_bypass),
    .w_we_rt_bypass(w_we_rt_bypass),
    .w_me_rs_bypass(w_me_rs_bypass),
    .w_me_rt_bypass(w_me_rt_bypass)
);

mux_421 #(1) stall_generator (.w_input00_x(1'b0), .w_input01_x(1'b1), .w_input10_x((w_stall | r_ebranch_op & r_ealu_br_condition | r_ejump_op)), .w_input11_x((w_stall | r_ebranch_op & r_ealu_br_condition | r_ejump_op)), .w_out_x(w_dreg_reset), .w_ctrl_2(decode_stage_ctrl_reg_reset));

//Fetched instr register
register_sync #(32) instr_reg_32 (.clock(clock), .reset((w_dreg_reset & (~w_ebranch_op & ~w_ejump_op))), .w_in(instr_mem_data_out), .w_out(r_instr_reg_out_32));
register_sync #(32) fpc_reg_32 (.clock(clock), .reset(w_dreg_reset), .w_in(r_PC), .w_out(r_fpc));
///////////////////////////////////////////////DECODE_CTRL_SIGNALS/////////////////////////////////////////////////////////////////
//op type
register_sync #(32) dpc_reg_32 (.clock(clock), .reset((w_dreg_reset & (~w_ebranch_op & ~w_ejump_op))), .w_in(instr_mem_addr), .w_out(r_dpc));

register_sync #(1) dalu_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_alu_op), .w_out(r_dalu_op));
register_sync #(1) dunsigned_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_unsigned_op), .w_out(r_dunsigned_op));
register_sync #(1) dimm_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_imm_op), .w_out(r_dimm_op));
register_sync #(1) dbyte_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_byte_op), .w_out(r_dbyte_op));
register_sync #(1) dshift_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_shift_op), .w_out(r_dshift_op));
register_sync #(1) dmem_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_mem_op), .w_out(r_dmem_op));
register_sync #(1) dwrite_op_reg_1(.clock(clock), .reset(w_dreg_reset), .w_in(w_write_op), .w_out(r_dwrite_op));
register_sync #(1) dbranch_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_branch_op), .w_out(r_dbranch_op));
register_sync #(1) djump_op_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_jump_op), .w_out(r_djump_op));
register_sync #(1) dnop_reg_1 (.clock(clock), .reset(w_dreg_reset), .w_in(w_nop), .w_out(r_dnop));
//op code
register_sync #(6) dop_code_reg_6 (.clock(clock), .reset(w_dreg_reset), .w_in(w_op_type_6), .w_out(r_dop_type_6));
//reg params
register_sync #(5) drs_reg_5 (.clock(clock), .reset(w_dreg_reset), .w_in(w_rs_5), .w_out(r_drs_5));
register_sync #(5) drt_reg_5 (.clock(clock), .reset(w_dreg_reset), .w_in(w_rt_5), .w_out(r_drt_5));
register_sync #(5) drd_reg_5 (.clock(clock), .reset(w_dreg_reset), .w_in(w_rd_5), .w_out(r_drd_5));
register_sync #(5) dsh_reg_5 (.clock(clock), .reset(w_dreg_reset), .w_in(w_sh_5), .w_out(r_dsh_5));
register_sync #(6) dfunc_code_reg_6 (.clock(clock), .reset(w_dreg_reset), .w_in(w_func_6), .w_out(r_dfunc_6));
//imms
register_sync #(16) dalu_imm_reg_16 (.clock(clock), .reset(w_dreg_reset), .w_in(w_alu_imm_16), .w_out(r_dalu_imm_16));
register_sync #(26) dbr_imm_reg_26 (.clock(clock), .reset(w_dreg_reset), .w_in(w_br_imm_26), .w_out(r_dbr_imm_26));
//raw instr (for debugging)
register_sync #(32) ddecoder_instr_output(.clock(clock), .reset(w_dreg_reset), .w_in(w_decoder_instr_out_32), .w_out(r_decoder_instr_out_32));

///////////////////////////////////////////////EXECUTION_CTRL_SIGNALS/////////////////////////////////////////////////////////////////
//registering control signals
register_sync #(32) epc_reg_32 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dpc), .w_out(r_epc));

//op type
register_sync #(1) ealu_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dalu_op), .w_out(r_ealu_op));
register_sync #(1) eunsigned_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dunsigned_op), .w_out(r_eunsigned_op));
register_sync #(1) eimm_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dimm_op), .w_out(r_eimm_op));
register_sync #(1) ebyte_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dbyte_op), .w_out(r_ebyte_op));
register_sync #(1) eshift_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dshift_op), .w_out(r_eshift_op));
register_sync #(1) emem_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dmem_op), .w_out(r_emem_op));
register_sync #(1) ewrite_op_reg_1(.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dwrite_op), .w_out(r_ewrite_op));
register_sync #(1) ebranch_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dbranch_op), .w_out(r_ebranch_op));
register_sync #(1) ejump_op_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_djump_op), .w_out(r_ejump_op));
register_sync #(1) enop_reg_1 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dnop), .w_out(r_enop));
//op code
register_sync #(6) eop_code_reg_6 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dop_type_6), .w_out(r_eop_type_6));
//reg params
register_sync #(5) ers_reg_5 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_drs_5), .w_out(r_ers_5));
register_sync #(5) ert_reg_5 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_drt_5), .w_out(r_ert_5));
register_sync #(5) erd_reg_5 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_drd_5), .w_out(r_erd_5));
//imm vals
register_sync #(26) ebr_imm_reg_26 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dbr_imm_26), .w_out(r_ebr_imm_26));
register_sync #(16) ealu_imm_reg_16 (.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_dalu_imm_16), .w_out(r_ealu_imm_16));
//raw instr (for debugging)
register_sync #(32) edecoder_instr_output(.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(r_decoder_instr_out_32), .w_out(r_exec_instr_out_32));

//rt value register
register_sync #(32) ert_data_value_reg_32(.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(w_reg_file_dout2_32), .w_out(r_ert_data_32));
//ALU output register
register_sync #(32) ealu_output_reg_32(.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(w_alu_out_32), .w_out(r_ealu_out_32));
register_sync #(1) ealu_br_condition_reg_1(.clock(clock), .reset((execution_stage_ctrl_reg_reset | w_dreg_reset)), .w_in(w_alu_br_condition), .w_out(r_ealu_br_condition));

///////////////////////////////////////////////MEMORY_CTRL_SIGNALS/////////////////////////////////////////////////////////////////
register_sync #(32) mpc_reg_32 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_epc), .w_out(r_mpc));

//registering output of memory and control signals
register_sync #(1) malu_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ealu_op), .w_out(r_malu_op)); 
register_sync #(1) munsigned_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_eunsigned_op), .w_out(r_munsigned_op));
register_sync #(1) mimm_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_eimm_op), .w_out(r_mimm_op));
register_sync #(1) mbyte_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ebyte_op), .w_out(r_mbyte_op));
register_sync #(1) mshift_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_eshift_op), .w_out(r_mshift_op));
register_sync #(1) mmem_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_emem_op), .w_out(r_mmem_op));
register_sync #(1) mwrite_op_reg_1(.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ewrite_op), .w_out(r_mwrite_op));
register_sync #(1) mbranch_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ebranch_op), .w_out(r_mbranch_op));
register_sync #(1) mjump_op_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ejump_op), .w_out(r_mjump_op));
register_sync #(1) mnop_reg_1 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_enop), .w_out(r_mnop));
//op code
register_sync #(6) mop_code_reg_6 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_eop_type_6), .w_out(r_mop_type_6));
//reg params
register_sync #(5) mrs_reg_5 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ers_5), .w_out(r_mrs_5));
register_sync #(5) mrt_reg_5 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ert_5), .w_out(r_mrt_5));
register_sync #(5) mrd_reg_5 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_erd_5), .w_out(r_mrd_5));
//imms
register_sync #(16) malu_imm_reg_16 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ealu_imm_16), .w_out(r_malu_imm_16));
register_sync #(26) mbr_imm_reg_26 (.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ebr_imm_26), .w_out(r_mbr_imm_26));
//rt value register
register_sync #(32) mrt_data_value_reg_32(.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ert_data_32), .w_out(r_mrt_data_32));

//ALU output register
register_sync #(32) malu_output_reg_32(.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_ealu_out_32), .w_out(r_malu_out_32));

//memory output register
register_sync #(32) mdmem_output_reg_32(.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(w_dmem_data_out_32), .w_out(r_mdmem_data_32));
register_sync #(8) mdmem_output_reg_8(.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(w_dmem_data_out_8), .w_out(r_mdmem_data_8));
//raw instr (for debugging)
register_sync #(32) mdecoder_instr_output(.clock(clock), .reset(memory_stage_ctrl_reg_reset), .w_in(r_exec_instr_out_32), .w_out(r_mem_instr_out_32));

/***************************************************************************************************************






/////////////////////////////////Non control wiring begins//////////////////////////////////////////////////////






*****************************************************************************************************************/
//pc register
//pc_register #(32) PC_REGISTER (.clock(clock), .reset(MANUAL_PC_CTRL), .w_in(PC), .w_out(r_PC));

//ALU input wiring
alu_input_ctrlr alu_in_ctrl (
    .w_mem_op(r_dmem_op),
    .w_imm_op(r_dimm_op),
    .w_shift_op(r_dshift_op),
    .w_alu_lhs_ctrl(alu_lhs_ctrl),
    .w_alu_rhs_ctrl(alu_rhs_ctrl)
);

//reg file -> alu wiring
sgn_extension_unit alu_in_sgn_extension_unit (.w_input_x(r_dalu_imm_16), .w_output_32(w_dalu_imm_signextended_32));

mux_221 #(32) alu_imm(.w_input0_x({16'b0, r_dalu_imm_16}), .w_input1_x(w_dalu_imm_signextended_32), .w_out_x(w_alu_imm_32), .w_ctrl(r_dunsigned_op));

//if both M->E and W->E take M->E since its most up-to-date
mux_421 #(32) alu_rfrs_mrs_ers_bypass_mux(.w_input00_x(w_reg_file_dout1_32), .w_input01_x(w_reg_file_dval_32), .w_input10_x(r_ealu_out_32), .w_input11_x(r_ealu_out_32), .w_out_x(w_rs_bypass_mux_32), .w_ctrl_2({w_me_rs_bypass, w_we_rs_bypass}));
mux_421 #(32) alu_rfrt_mrt_ert_bypass_mux(.w_input00_x(w_reg_file_dout2_32), .w_input01_x(w_reg_file_dval_32), .w_input10_x(r_ealu_out_32), .w_input11_x(r_ealu_out_32), .w_out_x(w_rt_bypass_mux_32), .w_ctrl_2({w_me_rt_bypass, w_we_rt_bypass}));

mux_421 #(32) alu_rs_rt_sh_imm_mux (.w_input00_x(w_rs_bypass_mux_32), .w_input01_x(w_rt_bypass_mux_32), .w_input10_x({27'b0, r_dsh_5}), .w_input11_x(w_alu_imm_32), .w_out_x(w_alu_rhs_32), .w_ctrl_2(alu_rhs_ctrl));
mux_221 #(32) alu_rs_rt_mux (.w_input0_x(w_rs_bypass_mux_32), .w_input1_x(w_rt_bypass_mux_32), .w_out_x(w_alu_lhs_32), .w_ctrl(alu_lhs_ctrl));

//branch ctrlr wiring
sgn_extension_unit #(18) alu_imm_sgn_ext(.w_input_x({r_ealu_imm_16, 2'b0}), .w_output_32(r_ealu_imm_sgn_ext_32)); 
branch_ctrlr branch_ctrl(
    .w_branch_op(r_ebranch_op),
    .w_success(r_ealu_br_condition),
    .w_jump_op(r_ejump_op),
    .w_imm_op(r_eimm_op),
    .w_stall(w_stall),
    .w_dpc_in_32(r_dpc),
    .w_epc_in_32(r_mpc),
    .w_pc_32(input_r_PC),
    .w_alu_imm_32(r_ealu_imm_sgn_ext_32),
    .w_br_imm_26(r_ebr_imm_26),
    .w_reg_pc_32(r_ert_data_32),
    .w_pc_out_32(PC),
    .w_pc_advanced_out_32(w_advanced_pc_32)
);

//write_back -> register file input wiring
reg_file_waddr_ctrlr wb_wadder_ctrlr (
    .w_alu_op(r_malu_op),
    .w_imm_op(r_mimm_op),
    .w_mem_op(r_mmem_op),
    .w_write_op(r_mwrite_op),
    .w_en_out(w_reg_file_wen),
    .w_waddr_ctrlr_out(w_reg_file_waddr_ctrl)
);

reg_file_wdata_ctrlr wb_wdata_ctrlr(
    .w_alu_op(r_malu_op),
    .w_mem_op(r_mmem_op),
    .w_byte_op(r_mbyte_op),
    .w_imm_op(r_mimm_op),
    .w_wdata_ctrl_out_2(w_reg_file_wdata_ctrl)
);

mux_221 #(32) dmem_ert_wb_mux(.w_input0_x(r_ert_data_32), .w_input1_x(w_reg_file_dval_32), .w_out_x(w_dmem_data_in_32), .w_ctrl(w_wm_rt_bypass));

sgn_extension_unit #(8) wb_in_sgn_ext_unit (.w_input_x(r_mdmem_data_8), .w_output_32(w_sgn_ext_mdmem_data_8));
mux_221 #(5) reg_file_waddr_rd_rt(.w_input0_x(r_mrd_5), .w_input1_x(r_mrt_5), .w_out_x(w_reg_file_daddr_5), .w_ctrl(w_reg_file_waddr_ctrl));
mux_421 #(32) reg_file_wdata_mem_imm(.w_input00_x(r_mdmem_data_32), .w_input01_x(w_sgn_ext_mdmem_data_8), .w_input10_x({r_malu_imm_16, 16'b0}), .w_input11_x(r_malu_out_32), .w_out_x(w_reg_file_dval_32), .w_ctrl_2(w_reg_file_wdata_ctrl));

assign instr_mem_addr_mux_ctrl = {(w_stall | r_ebranch_op | r_ejump_op), manual_addressing};
//// INSTRUCTION MEMORY INPUT METHOD IS SKETCHY AS FUCK, ASK ME BEFORE CHANGING IT 
mux_421 #(32) instr_mem_input_mux (.w_input00_x(r_PC), .w_input01_x(MANUAL_PC), .w_input10_x(w_advanced_pc_32), .w_input11_x(w_advanced_pc_32), .w_out_x(instr_mem_addr), .w_ctrl_2(instr_mem_addr_mux_ctrl));

//memory population loop
always @(posedge clock) begin
    if(~(read_instrs[counter] === 32'bx))
    begin
        if(~instr_mem_rw)
        begin
#0.25       MANUAL_PC = MANUAL_PC + 4;
            instr_mem_data_in = read_instrs[counter];
            counter = counter + 1;
        end
    end
    else
        begin
            if(writing)
                begin
                    //MANUAL_PC_CTRL = 0;
                    #1 r_PC = PC_BASE_ADDR - 4;
                    writing = 0;
                    decode_stage_ctrl_reg_reset = 2'b10;
                    execution_stage_ctrl_reg_reset = 0;
                    memory_stage_ctrl_reg_reset = 0;
                    manual_addressing = 0;
                    instr_reg_reset = 0;
                    instr_mem_rw = 1;
                    $display("Resetting... PC:%h", r_PC);
                end
        end
end

//fetch loop
always @(posedge clock) begin
    if(~writing)
    begin
    #0.05 r_PC = PC;
    end
end

//clock
always begin
    #2 clock = ~clock;
end

endmodule