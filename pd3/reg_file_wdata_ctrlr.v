module reg_file_wdata_ctrlr(
    w_alu_op,
    w_mem_op,
    w_byte_op,
    w_imm_op,
    w_wdata_ctrl_out_2
);
input wire w_alu_op, w_mem_op, w_byte_op, w_imm_op;
output reg [1:0] w_wdata_ctrl_out_2;

wire [3:0] op = {w_alu_op, w_mem_op, w_byte_op, w_imm_op};

always @(*) begin
  case(op)
    4'b0100:
        w_wdata_ctrl_out_2 = 2'b00;
    4'b0110:
        w_wdata_ctrl_out_2 = 2'b01;
    4'b0101:
        w_wdata_ctrl_out_2 = 2'b10;
    4'b100x:
        w_wdata_ctrl_out_2 = 2'b11;
    default:
        w_wdata_ctrl_out_2 = 2'bXX;
  endcase
end
endmodule