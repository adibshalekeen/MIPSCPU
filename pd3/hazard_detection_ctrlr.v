module hazard_detection_ctrlr(
    w_alu_op,
    w_imm_op,
    w_mem_op,
    w_write_op,
    w_branch_op,
    w_jump_op,
    w_nop,
    w_rs_addr_5,
    w_rt_addr_5,
    w_rd_addr_5,
    w_dalu_op,
    w_dimm_op,
    w_dmem_op,
    w_dwrite_op,
    w_dbranch_op,
    w_djump_op,
    w_dnop,
    w_drs_addr_5,
    w_drt_addr_5,
    w_drd_addr_5,
    w_ealu_op,
    w_eimm_op,
    w_emem_op,
    w_ewrite_op,
    w_ebranch_op,
    w_ejump_op,
    w_enop,
    w_ers_addr_5,
    w_ert_addr_5,
    w_erd_addr_5,
    w_malu_op,
    w_mimm_op,
    w_mmem_op,
    w_mwrite_op,
    w_mbranch_op,
    w_mjump_op,
    w_mnop,
    w_mrs_addr_5,
    w_mrt_addr_5,
    w_mrd_addr_5,
    w_dctrl_reg_reset,
    w_stall,
    w_wm_rt_bypass,
    w_we_rs_bypass,
    w_we_rt_bypass,
    w_me_rs_bypass,
    w_me_rt_bypass
);
input wire w_alu_op, w_mem_op, w_write_op, w_branch_op, w_jump_op, w_nop;
input wire [4:0] w_rs_addr_5, w_rt_addr_5, w_rd_addr_5;

input wire w_dalu_op, w_dmem_op, w_dwrite_op, w_dbranch_op, w_djump_op, w_dnop;
input wire [4:0] w_drs_addr_5, w_drt_addr_5, w_drd_addr_5;

input wire w_ealu_op, w_emem_op, w_ewrite_op, w_ebranch_op, w_ejump_op, w_enop;
input wire [4:0] w_ers_addr_5, w_ert_addr_5, w_erd_addr_5;

input wire w_malu_op, w_mmem_op, w_mwrite_op, w_mbranch_op, w_mjump_op, w_mnop;
input wire [4:0] w_mrs_addr_5, w_mrt_addr_5, w_mrd_addr_5;

output wire w_dctrl_reg_reset;

output wire w_stall, w_wm_bypass, w_we_lhs_bypass, w_we_rhs_bypass, w_me_bypass;

wire [3:0] exec_bypass_sig;

always @(*)begin
    //load-use stall for alu instructions (str can bypass)
    if((w_dmem_op & ~w_dwrite_op) & ((w_rs_addr_5 === w_drt_addr_5) | ((w_rt_addr_5 === w_drt_addr_5) & ~(w_mem_op & w_write_op)))
        w_stall = 1;
        w_dctrl_reg_reset = 1;
    else
        w_stall = 0;
        w_dctrl_reg_reset = 0;
end

assign exec_bypass_sig = {w_ealu_op, w_eimm_op, w_malu_op, w_mimm_op};

always @(*) begin
    //mem -> exec bypass
    case(exec_bypass_sig)
    4'b1100, 4'b1101, 4'1110, 4'1111:
        begin
            if((w_drs_addr_5 === w_ert_addr_5))
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;
            
            if((w_drt_addr_5 === w_ert_addr_5))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
        end
    4'b1000, 4'1001, 4'1010, 4'1011:
        begin
            if((w_drs_addr_5 === w_erd_addr_5))
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;

            if((w_drt_addr_5 === w_erd_addr_5))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
        end
    4'0011:
        begin
             if((w_drs_addr_5 === w_mrt_addr_5))
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;
            
            if((w_drt_addr_5 === w_mrt_addr_5))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
        end
    4'0010:
        begin
            if((w_drs_addr_5 === w_mrd_addr_5))
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;

            if((w_drt_addr_5 === w_mrd_addr_5))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
        end
    endcase
end

always @(*) begin
    //writeback -> mem bypass (M = SW, WB = LW)
    if(w_mmem_op & ~w_mwrite_op & (w_ert_addr_5 === w_mrt_addr_5))
        w_wm_bypass = 1;
    else
        w_wm_bypass = 0;
end
endmodule