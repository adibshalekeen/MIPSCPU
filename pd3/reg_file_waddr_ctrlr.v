module reg_file_waddr_ctrlr(
    w_alu_op,
    w_imm_op,
    w_mem_op,
    w_write_op,
    w_en_out,
    w_waddr_ctrlr_out
);
input wire w_alu_op, w_mem_op, w_write_op, w_imm_op;
output wire w_en_out;
output reg w_waddr_ctrlr_out;

assign w_en_out = w_alu_op | (w_mem_op & ~w_write_op);

always @(w_mem_op, w_alu_op) begin
    if(w_mem_op | (w_alu_op & w_imm_op))
        w_waddr_ctrlr_out = 1;
    else if (w_alu_op)
        w_waddr_ctrlr_out = 0;
    else
        w_waddr_ctrlr_out = 1'bX;
end
endmodule