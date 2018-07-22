`include "isa_codes.v"
module ALU #(parameter WIDTH = 32)(
    w_op_code_6,
    w_mem_op,
    w_branch_op,
    w_input1_x,
    w_input2_x,
    w_output_condition,
    w_output_x
);
input wire w_mem_op, w_branch_op;
input wire [5:0] w_op_code_6;
input wire [WIDTH-1:0] w_input1_x, w_input2_x;
output reg [WIDTH-1:0] w_output_x;
output reg w_output_condition = 0;

reg signed[WIDTH-1:0] temp_signedi1;
reg signed[WIDTH-1:0] temp_signedi2;

reg signed[2*WIDTH:0] long_temp_signed;
reg [2*WIDTH:0] long_temp_unsigned;

reg [31:0] HI = 0;
reg [31:0] LO = 0;

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
        if(w_branch_op)
        begin
                case(w_op_code_6)   
                `BEQ:
                        begin
                        $display("EQ!: %h 1: %h 2: %h", BEQ, w_input1_x, w_input2_x);
                        w_output_x = 32'bX;
                        w_output_condition = BEQ;
                        end
                `BNE:
                        begin
                        w_output_x = 32'bX;
                        w_output_condition = BNE;
                        end
                `BGTZ:
                        begin
                        w_output_x = 32'bX;
                        w_output_condition = BGTZ;
                        end
                `BGEZ:
                        begin
                        w_output_x = 32'bX;
                        w_output_condition = BGEZ;
                        end
                `BLTZ:
                        begin
                        w_output_x = 32'bX;
                        w_output_condition = BLTZ;
                        end
                `BLEZ:
                        begin
                        w_output_x = 32'bX;
                        w_output_condition = BLEZ;
                        end
                default:
                        begin
                        w_output_x = 32'hXXXXXXXX;
                        w_output_condition = 0;
                        end
                endcase 
        end
        else if (w_mem_op)
        begin
                case(w_op_code_6)
                `LW, `SW, `LUI, `LB, `LBU, `SB:
                        begin
                        if(w_op_code_6 == `LUI)
                                w_output_x = {temp_signedi2, 16'b0};
                        else
                                w_output_x = temp_signedi1 + temp_signedi2;
                        w_output_condition = 0;
                        end
                default:
                        begin
                        w_output_x = 32'hXXXXXXXX;
                        w_output_condition = 0;
                        end
                endcase
        end
        else
        begin
                case(w_op_code_6)
                `SPECIAL_ADD:
                        begin
                        w_output_x = temp_signedi1 + temp_signedi2;
                        w_output_condition = 0;
                        end
                `SPECIAL_ADDU, `ADDIU:
                        begin
                        w_output_x = w_input1_x + w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_SUB:
                        begin
                        w_output_x = temp_signedi1 - temp_signedi2;
                        w_output_condition = 0;
                        end
                `SPECIAL_SUBU:
                        begin
                        w_output_x = w_input1_x - w_input2_x;
                        w_output_condition = 0;
                        end
                `MUL:
                        begin
                        long_temp_signed = temp_signedi1 * temp_signedi2;
                        w_output_x = long_temp_signed[31:0];
                        w_output_condition = 0;
                        end
                `SPECIAL_MULT:
                        begin
                        long_temp_signed = temp_signedi1 * temp_signedi2;
                        HI = long_temp_signed[(2*WIDTH - 1):WIDTH];
                        LO = long_temp_signed[(WIDTH - 1):0];
                        w_output_x = 32'bX;
                        w_output_condition = 0;
                        end
                `SPECIAL_MULTU:
                        begin
                        long_temp_unsigned = w_input1_x * w_input2_x;
                        HI = long_temp_unsigned[(2*WIDTH - 1):WIDTH];
                        LO = long_temp_unsigned[(WIDTH - 1):0];
                        w_output_x = 32'bX;
                        w_output_condition = 0;
                        end
                `SPECIAL_DIV:
                        begin
                        long_temp_signed = temp_signedi1 / temp_signedi2;
                        HI = long_temp_signed[(2*WIDTH - 1):WIDTH];
                        LO = long_temp_signed[(WIDTH - 1):0];
                        w_output_x = 32'bX;
                        w_output_condition = 0;
                        end
                `SPECIAL_DIVU:
                        begin
                        long_temp_unsigned = w_input1_x / w_input2_x;
                        HI = long_temp_unsigned[(2*WIDTH - 1):WIDTH];
                        LO = long_temp_unsigned[(WIDTH - 1):0];
                        w_output_x = 32'bX;
                        w_output_condition = 0;
                        end
                `SPECIAL_MFHI:
                        begin
                        w_output_x = HI;
                        w_output_condition = 0;
                        end
                `SPECIAL_MFLO:
                        begin
                        w_output_x = LO;
                        w_output_condition = 0;
                        end
                `SPECIAL_SLT, `SLTI:
                        begin
                        w_output_x = temp_signedi1 < temp_signedi2;
                        w_output_condition = 0;
                        end
                `SPECIAL_SLTU, `SLTIU:
                        begin
                        w_output_x = w_input1_x < w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_SLL, `SPECIAL_SLLV:
                        begin
                        w_output_x = temp_signedi1 << w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_SRL, `SPECIAL_SRLV:
                        begin
                        w_output_x = temp_signedi1 >> w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_SRA, `SPECIAL_SRAV:
                        begin
                        w_output_x = temp_signedi1 <<< w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_OR, `ORI:
                        begin
                        w_output_x = w_input1_x | w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_XOR, `XORI:
                        begin
                        w_output_x = w_input1_x ^ w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_NOR:
                        begin
                        w_output_x = !(w_input1_x | w_input2_x); 
                        w_output_condition = 0;
                        end
                `SPECIAL_AND, `ANDI:
                        begin
                        w_output_x = w_input1_x & w_input2_x;
                        w_output_condition = 0;
                        end
                `SPECIAL_NOP:
                        begin
                        w_output_x = 32'hFFFFFFFF;
                        w_output_condition = 0;
                        end
                default:
                        begin
                        w_output_x = 32'hXXXXXXXX;
                        w_output_condition = 0;
                        end        
                endcase
        end
end
endmodule