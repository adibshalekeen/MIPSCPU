module hazard_detection_ctrlr(
    clock,
    w_alu_op,
    w_shift_op,
    w_imm_op,
    w_jump_op,
    w_mem_op,
    w_write_op,
    w_rs_addr_5,
    w_rt_addr_5,
    w_dalu_op,
    w_dimm_op,
    w_dshift_op,
    w_dmem_op,
    w_dwrite_op,
    w_djump_op,
    w_drs_addr_5,
    w_drt_addr_5,
    w_drd_addr_5,
    w_ealu_op,
    w_eimm_op,
    w_eshift_op,
    w_emem_op,
    w_ejump_op,
    w_ewrite_op,
    w_ers_addr_5,
    w_ert_addr_5,
    w_erd_addr_5,
    w_malu_op,
    w_mimm_op,
    w_mshift_op,
    w_mmem_op,
    w_mwrite_op,
    w_mjump_op,
    w_wb_regfile_addr_5,
    w_reg_file_rd_addr1,
    w_reg_file_rd_addr2,
    w_reg_file_en,
    w_stall,
    w_wm_rt_bypass,
    w_we_rs_bypass,
    w_we_rt_bypass,
    w_me_rs_bypass,
    w_me_rt_bypass,
    w_wm_jump_bypass
);
input wire w_mem_op, w_alu_op, w_imm_op, w_jump_op, w_write_op, w_shift_op, clock;
input wire [4:0] w_rs_addr_5, w_rt_addr_5;
input wire w_reg_file_en;
input wire w_dalu_op, w_dimm_op, w_dmem_op, w_dwrite_op, w_dshift_op, w_djump_op;
input wire [4:0] w_drs_addr_5, w_drt_addr_5, w_drd_addr_5;

input wire w_ealu_op, w_eimm_op, w_emem_op, w_ejump_op, w_ewrite_op, w_eshift_op;
input wire [4:0] w_ers_addr_5, w_ert_addr_5, w_erd_addr_5;

input wire w_malu_op, w_mimm_op, w_mmem_op, w_mwrite_op, w_mshift_op, w_mjump_op;
input wire [4:0] w_wb_regfile_addr_5, w_reg_file_rd_addr1, w_reg_file_rd_addr2;

output reg w_stall = 0;
output reg w_wm_rt_bypass, w_we_rs_bypass, w_we_rt_bypass, w_me_rs_bypass, w_me_rt_bypass;
output reg w_wm_jump_bypass = 0;

wire execution_stage_str;
wire wb_stage_str;

wire mem_stage_r_type = 0;
wire mem_stage_l_type = 0;

always @(*)begin
    //load-use stall for alu instructions (str can bypass)
    if((w_dmem_op & ~w_dwrite_op) & ((w_rs_addr_5 === w_drt_addr_5) | ((w_rt_addr_5 === w_drt_addr_5) & ~(w_mem_op & w_write_op))))
        w_stall = 1;
    else if (w_jump_op & ~w_imm_op)
        begin
            if((w_rs_addr_5 === w_drd_addr_5) & (~w_dimm_op | w_dshift_op))
                w_stall = 1;
            else if((w_rs_addr_5 === w_drt_addr_5) & (w_dmem_op | w_dimm_op) & ~w_dshift_op)
                w_stall = 1;
            else
                w_stall = 0;

            if((w_rs_addr_5 === w_erd_addr_5) & (~w_eimm_op | w_eshift_op))
                w_stall = 1;
            else if((w_rs_addr_5 === w_ert_addr_5) & (w_emem_op | w_eimm_op) & ~w_eshift_op)
                w_stall = 1;
            else
                w_stall = 0;
        end
    else if ((w_drs_addr_5 === w_wb_regfile_addr_5) & w_reg_file_en & w_dimm_op)
        w_stall = 1;
    else if ((w_drt_addr_5 === w_wb_regfile_addr_5) & w_reg_file_en & (~w_dimm_op | w_dshift_op))
        w_stall = 1;
    else
        w_stall = 0;
end

assign execution_stage_str = w_dmem_op & w_dwrite_op;
assign wb_stage_str = w_mmem_op & w_mwrite_op;
always @(*) begin
    //mem -> exec bypass
    if(w_ealu_op & w_eimm_op)
    begin
            if(w_eshift_op)
            begin
            if((w_drs_addr_5 === w_erd_addr_5) & ~w_dimm_op)
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;
            
            if((w_drt_addr_5 === w_erd_addr_5) & ~execution_stage_str & (~w_dimm_op | w_dshift_op))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
            end
            else
            begin
            if((w_drs_addr_5 === w_ert_addr_5) & ~w_dimm_op)
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;
            
            if((w_drt_addr_5 === w_ert_addr_5) & ~execution_stage_str & (~w_dimm_op | w_dshift_op))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
            end
    end
    else if(w_ealu_op)
        begin
            if((w_drs_addr_5 === w_erd_addr_5))
                w_me_rs_bypass = 1;
            else
                w_me_rs_bypass = 0;

            if((w_drt_addr_5 === w_erd_addr_5) & ~execution_stage_str & (~w_dimm_op | w_dshift_op))
                w_me_rt_bypass = 1;
            else
                w_me_rt_bypass = 0;
        end
    else
        begin
            w_me_rs_bypass = 0;
            w_me_rt_bypass = 0;
        end
    //wb -> exec bypass
    if (((w_malu_op & w_mimm_op) | w_malu_op | (w_mmem_op & ~w_mwrite_op)))
        begin
             if((w_drs_addr_5 === w_wb_regfile_addr_5))
                w_we_rs_bypass = 1;
            else
                w_we_rs_bypass = 0;
            
            if((w_drt_addr_5 === w_wb_regfile_addr_5) & ~execution_stage_str & (~w_dimm_op | w_dshift_op))
                w_we_rt_bypass = 1;
            else
                w_we_rt_bypass = 0;
        end
    else
    begin
        w_we_rs_bypass = 0;
        w_we_rt_bypass = 0;
    end

    if(w_emem_op & ~wb_stage_str)
    begin
        if(w_ert_addr_5 === w_wb_regfile_addr_5)
            w_wm_rt_bypass = 1;
        else
            w_wm_rt_bypass = 0;
    end
    else
        w_wm_rt_bypass = 0;

    if(w_ejump_op)
    begin
        if((w_ers_addr_5 === w_wb_regfile_addr_5) & w_reg_file_en)
            w_wm_jump_bypass = 1;
        else
            w_wm_jump_bypass = 0;
    end

    //if bypass paths from wb and mem take wb
    if(w_wm_rt_bypass & w_me_rt_bypass)
        begin
            w_we_rt_bypass = 1;
            w_me_rt_bypass = 0;
        end

    if (w_me_rt_bypass & w_we_rt_bypass)
        w_we_rt_bypass = 0;
    
    if (w_me_rs_bypass & w_we_rs_bypass)
        w_we_rs_bypass = 0;

end
endmodule