module branch_ctrlr(
    w_branch_op,
    w_success,
    w_jump_op,
    w_imm_op,
    w_stall,
    w_br_pc_in_32,
    w_pc_32,
    w_alu_imm_32,
    w_br_imm_26,
    w_reg_pc_32,
    w_pc_out_32
);
input wire w_branch_op, w_imm_op, w_success, w_jump_op, w_stall;
input wire [31:0] w_br_pc_in_32, w_pc_32;
input wire [31:0] w_alu_imm_32, w_reg_pc_32;
input wire [25:0] w_br_imm_26;
output reg [31:0] w_pc_out_32;

reg [31:0] branch_delay_slot;

always @(*) begin
    branch_delay_slot = w_br_pc_in_32 + 4;
    if(w_branch_op & w_success)
        begin
        w_pc_out_32 = branch_delay_slot + w_alu_imm_32;
        $display("Branch taken", w_pc_out_32);
        end
    else if (w_jump_op)
        begin
            if(w_imm_op)
            begin
                w_pc_out_32 = {branch_delay_slot[31:30], w_br_imm_26[25:0], 4'b0};
                $display("Jump imm taken", w_pc_out_32);
            end
            else
            begin
                w_pc_out_32 = w_reg_pc_32;
                $display("Jump reg taken", w_reg_pc_32);
            end
        end
    else
        if(w_stall)
            w_pc_out_32 = w_pc_32 - 4;
        else
            w_pc_out_32 = w_pc_32 + 4;
        $display("Branch Control: pc_in: %h, pc_out: %h", w_pc_32, w_pc_out_32);
end
endmodule