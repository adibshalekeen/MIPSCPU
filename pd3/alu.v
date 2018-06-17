`include "isa_codes.v"
module ALU #(parameter WIDTH = 32)(
    w_op_code_6,
    w_input1_x,
    w_input2_x,
    w_output_x
);
input wire [5:0] w_op_code_6;
input wire [WIDTH-1:0] w_input1_x, w_input2_x;
output reg [WIDTH-1:0] w_output_x;

reg signed[WIDTH-1:0] temp_signedi1;
reg signed[WIDTH-1:0] temp_signedi2;

wire BEQ, BNE, BGTZ, BLEZ, BGEZ, BLTZ;

assign BEQ = w_input1_x === w_input2_x;
assign BNE = w_input1_x != w_input2_x;
assign BGTZ = w_input1_x > 0;
assign BLTZ = w_input1_x < 0;
assign BGEZ = w_input1_x >= 0;
assign BLEZ = w_input1_x <= 0;

always @(*) begin
        temp_signedi1 = w_input1_x;
        temp_signedi2 = w_input2_x;      
        case(w_op_code_6)
        `SPECIAL_ADD:
                w_output_x = temp_signedi1 + temp_signedi2;
        `LW, `SW, `LUI, `LB, `LBU, `SB:
                w_output_x = w_input1_x + temp_signedi2;
        `SPECIAL_ADDU, `ADDIU:
                w_output_x = w_input1_x + w_input2_x;
        `SPECIAL_SUB:
                w_output_x = temp_signedi1 - temp_signedi2;
        `SPECIAL_SUBU:
                w_output_x = w_input1_x - w_input2_x;
        `SPECIAL_MULT:
                w_output_x = temp_signedi1 * temp_signedi2;
        `SPECIAL_MULTU:
                w_output_x = w_input1_x * w_input2_x;
        `SPECIAL_DIV:
                w_output_x = temp_signedi1 / temp_signedi2;
        `SPECIAL_DIVU:
                w_output_x = w_input1_x / w_input2_x;
        `SPECIAL_SLT, `SLTI:
                w_output_x = temp_signedi1 < temp_signedi2;
        `SPECIAL_SLTU, `SLTIU:
                w_output_x = w_input1_x < w_input2_x;
        `SPECIAL_SLL, `SPECIAL_SLLV:
                w_output_x = temp_signedi1 << w_input2_x;
        `SPECIAL_SRL, `SPECIAL_SRLV:
                w_output_x = temp_signedi1 >> w_input2_x;
        `SPECIAL_SRA, `SPECIAL_SRAV:
                w_output_x = temp_signedi1 <<< w_input2_x;
        `SPECIAL_OR, `ORI:
                w_output_x = w_input1_x | w_input2_x;
        `SPECIAL_XOR, `XORI:
                w_output_x = w_input1_x ^ w_input2_x;
        `SPECIAL_NOR:
                w_output_x = !(w_input1_x | w_input2_x); 
        `SPECIAL_AND:
                w_output_x = w_input1_x & w_input2_x;
        `BEQ:
                w_output_x = BEQ;
        `BNE:
                w_output_x = BNE;
        `BGTZ:
                w_output_x = BGTZ;
        `BGEZ:
                w_output_x = BGEZ;
        `BLTZ:
                w_output_x = BLTZ;
        `BLEZ:
                w_output_x = BLEZ;
        `SPECIAL_NOP:
                w_output_x = 32'hFFFFFFFF;
        endcase
end
endmodule