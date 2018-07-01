module alu_input_ctrlr(
    w_mem_op,
    w_imm_op,
    w_shift_op,
    w_alu_lhs_ctrl,
    w_alu_rhs_ctrl
);
input wire w_mem_op, w_imm_op, w_shift_op;
output reg w_alu_lhs_ctrl;
output reg [1:0] w_alu_rhs_ctrl;
always @(w_imm_op, w_shift_op)
    begin
        if(w_shift_op)
            begin
            w_alu_lhs_ctrl = 1;
                if(w_imm_op)
                    w_alu_rhs_ctrl = 2'b10;
                else
                    w_alu_rhs_ctrl = 2'b00;
            end
        else if(w_mem_op)
            begin
                w_alu_lhs_ctrl = 0;
                w_alu_rhs_ctrl = 2'b11;
            end
        else
            begin
                w_alu_lhs_ctrl = 0;
                if(w_imm_op)
                    w_alu_rhs_ctrl = 2'b11;
                else
                    w_alu_rhs_ctrl = 2'b01;
            end
    end
endmodule