`include "isa_codes.v"
module decoder(
    clock,
    w_instr_32,
    w_instr_out_32,
    w_alu_op,
    w_alu_imm_val_16,
    w_mem_op,
    w_branch_op,
    w_op_type_6,
    w_branch_imm_val_26,
    w_rs_addr_5,
    w_rt_addr_5,
    w_rd_addr_5,
    w_sh_amt_5,
    w_func_6,
    w_nop
);
input clock;
input wire [31:0] w_instr_32;

output wire [31:0] w_instr_out_32;

//alu control signals
output reg w_alu_op;
output wire [15:0] w_alu_imm_val_16;

//memory control signals
output reg w_mem_op;
output reg [31:0] w_mem_op_type_32;

//branch control singals
output reg w_branch_op;
output wire [25:0] w_branch_imm_val_26;

output reg w_nop;
output reg [5:0] w_op_type_6;

//register addresses & shift amt
output wire [4:0] w_rs_addr_5;
output wire [4:0] w_rt_addr_5;
output wire [4:0] w_rd_addr_5;
output wire [4:0] w_sh_amt_5;
output wire [5:0] w_func_6;

wire [5:0] op_code;

//seperate instructions into components
assign op_code = w_instr_32[31:26];
assign w_rs_addr_5 = w_instr_32[25:21];
assign w_rt_addr_5 = w_instr_32[20:16];
assign w_rd_addr_5 = w_instr_32[15:11];
assign w_sh_amt_5 = w_instr_32[10:6];
assign w_func_6 = w_instr_32[5:0]; 
assign w_alu_imm_val_16 = w_instr_32[15:0];
assign w_branch_imm_val_26 = w_instr_32[25:0];
assign w_instr_out_32 = w_instr_32;
always @(posedge clock) begin
    w_alu_op = 0;
    w_mem_op = 0;
    w_branch_op = 0;
    w_nop = 0;
    case(op_code)
        `SPECIAL:
        begin
            if(w_func_6 === `SPECIAL_JALR || w_func_6 === `SPECIAL_JR)
                w_mem_op = 1;
            else if (w_func_6 === `SPECIAL_NOP)
                w_nop = 1;
            else
                w_alu_op = 1;
            w_op_type_6 = w_func_6;
        end
        `ADDIU, `SLTI, `SLTIU, `ORI, `XORI:
        begin
            w_alu_op = 1;
            w_op_type_6 = op_code;
        end
        `LW, `SW, `LUI, `LB, `LBU, `SB:
        begin
            w_mem_op = 1;
            w_op_type_6 = op_code;
        end
        `J, `JAL, `BEQ, `BNE, `BGTZ, `BLEZ:
        begin
            w_branch_op = 1;
            w_op_type_6 = op_code;
        end
        `REGIMM:
        begin
            if(w_rt_addr_5 === `BGEZ || w_rt_addr_5 === `BLTZ)
            begin
                w_branch_op = 1;
                w_op_type_6 = w_rt_addr_5 << 1;
            end
            else
                w_nop = 1;
        end
        default w_nop = 1;
    endcase
end
endmodule