module branch_ctrlr(
    w_branch_op,
    w_success,
    w_jump_op,
    w_imm_op,
    w_br_pc_in_32,
    w_pc_32,
    w_alu_imm_32,
    w_br_imm_26,
    w_reg_pc_32,
    w_pc_out_32
);
input wire w_branch_op, w_imm_op, w_success, w_jump_op;
input wire [31:0] w_br_pc_in_32, w_pc_32;
input wire [31:0] w_alu_imm_32, w_reg_pc_32;
input wire [25:0] w_br_imm_26;
output reg [31:0] w_pc_out_32;

reg [31:0] branch_delay_slot;

always @(w_branch_op, w_success, w_jump_op, w_imm_op) begin
    branch_delay_slot = w_br_pc_in_32 + 4;
    if(w_branch_op & w_success)
        w_pc_out_32 = branch_delay_slot + w_alu_imm_32;
    else if (w_jump_op)
        begin
            if(w_imm_op)
                w_pc_out_32 = {branch_delay_slot[31:30], w_br_imm_26[25:0], 2'b0};
            else
                w_pc_out_32 = w_reg_pc_32;
        end
    else
        w_pc_out_32 = w_pc_32 + 4;
end
endmodule