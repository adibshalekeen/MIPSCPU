module data_mem_ctrlr (
    w_op_code,
    w_mem_op,
    w_byte_op,
    w_byte,
    w_rw,
    w_en
);
input wire w_mem_op;
input wire [5:0] w_op_code;
output wire w_byte, w_rw, w_en;
always @(*) begin
    if(w_mem_op)
        begin
            w_en = 1;
            if(w_op_code === `SW | w_op_code === `SB)
                w_rw = 1;
            else
                w_rw = 0;
    else
        w_en = 0;
end
endmodule