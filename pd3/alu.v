`include "isa_codes.v"
module ALU(# parameter WIDTH = 32)(
    w_op_code_6,
    w_sh_amt_5, 
    w_input1_x,
    w_input2_x,
    w_output_x
)
input w_op_code;
input [4:0] w_sh_amt_5;
input [WIDTH-1:0] w_input1_x, w_input2_x;
output [WIDTH-1:0] w_output_x;
always @(*) begin
    case(w_op_code)
    `SPECIAL_ADD, `SPECIAL_ADDU, `ADDIU:
        w_output_x = w_input1_x + w_input2_x;
    `SPECIAL_SUB, `SPECIAL_SUBU:
        w_output_x = w_input1_x - w_input2_x;
    `SPECIAL_MULT, `SPECIAL_MULTU:
        w_output_x = w_input1_x * w_input2_x;
    `SPECIAL_DIV, `SPECIAL_DIVU:
        w_output_x = w_input1_x / w_input2_x;
    `SPECIAL_SLT, `SPECIAL_SLTU, `SLTI, `SLTIU:
        w_output_x = w_input1_x < w_input2_x;
    `SPECIAL_SLL, `SPECIAL_SLLV:
    `SPECIAL_SRL, `SPECIAL_SRLV:
    `SPECIAL_SRA, `SPECIAL_SRAV:
    endcase
end
endmodule