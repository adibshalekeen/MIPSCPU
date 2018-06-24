`include "isa_codes.v"
module decoder(
    w_instr_32,
    w_instr_out_32,
    w_alu_op,
    w_unsigned_op,
    w_imm_op,
    w_byte_op,
    w_shift_op,
    w_alu_imm_val_16,
    w_mem_op,
    w_write_op,
    w_branch_op,
    w_jump_op,
    w_op_type_6,
    w_branch_imm_val_26,
    w_rs_addr_5,
    w_rt_addr_5,
    w_rd_addr_5,
    w_sh_amt_5,
    w_func_6,
    w_nop
);
input wire [31:0] w_instr_32;

output wire [31:0] w_instr_out_32;

//alu control signals
output reg w_alu_op;
output reg w_unsigned_op;
output reg w_imm_op;
output reg w_byte_op;
output reg w_shift_op;
output wire [15:0] w_alu_imm_val_16;

//memory control signals
output reg w_mem_op;
output reg w_write_op;
output reg [31:0] w_mem_op_type_32;

//branch control singals
output reg w_branch_op;
output reg w_jump_op;
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

always @(*) begin
    case(op_code)
        `SPECIAL:
        begin
            case(w_func_6)
            `SPECIAL_JALR, `SPECIAL_JR:
                begin
                    w_alu_op = 0;
                    w_unsigned_op = 0;
                    w_imm_op = 0;
                    w_byte_op = 0;
                    w_shift_op = 0;
                    w_mem_op = 0;
                    w_write_op = 0;
                    w_branch_op = 0;
                    w_jump_op = 1;
                    w_nop = 0;
                end
            `SPECIAL_ADDU, `SPECIAL_SUBU, `SPECIAL_MULTU, `SPECIAL_DIVU, `SPECIAL_SLTU:
                begin
                    w_alu_op = 1;
                    w_unsigned_op = 1;
                    w_imm_op = 0;
                    w_byte_op = 0;
                    w_mem_op = 0;
                    w_write_op = 0;
                    w_shift_op = 0;
                    w_branch_op = 0;
                    w_jump_op = 0;
                    w_nop = 0;
                end
            `SPECIAL_ADD, `SPECIAL_SUB, `SPECIAL_MULT, `SPECIAL_DIV, `SPECIAL_SLT:
                begin
                    w_alu_op = 1;
                    w_unsigned_op = 0;
                    w_imm_op = 0;
                    w_byte_op = 0;
                    w_shift_op = 0;
                    w_mem_op = 0;
                    w_write_op = 0;
                    w_branch_op = 0;
                    w_jump_op = 0;
                    w_nop = 0;
                end
            `SPECIAL_SLL, `SPECIAL_SRL, `SPECIAL_SRA:
                begin
                    w_alu_op = 1;
                    w_unsigned_op = 0;
                    w_imm_op = 1;
                    w_byte_op = 0;
                    w_shift_op = 1;
                    w_mem_op = 0;
                    w_write_op = 0;
                    w_branch_op = 0;
                    w_jump_op = 0;
                    w_nop = 0;
                end
            `SPECIAL_SLLV, `SPECIAL_SRLV, `SPECIAL_SRAV:
                begin
                    w_alu_op = 1;
                    w_unsigned_op = 0;
                    w_imm_op = 0;
                    w_byte_op = 0;
                    w_shift_op = 1;
                    w_mem_op = 0;
                    w_write_op = 0;
                    w_branch_op = 0;
                    w_jump_op = 0;
                    w_nop = 0;
                end
            default:
                begin
                    w_alu_op = 0;
                    w_unsigned_op = 0;
                    w_imm_op = 0;
                    w_byte_op = 0;
                    w_shift_op = 0;
                    w_mem_op = 0;
                    w_write_op = 0;
                    w_branch_op = 0;
                    w_jump_op = 0;
                    w_nop = 1;
                end
            endcase
            w_op_type_6 = w_func_6;
        end
        `ADDIU, `SLTI, `SLTIU, `ORI, `XORI:
        begin
            w_alu_op = 1;
            if(op_code === `ADDIU | op_code === `SLTIU)
                w_unsigned_op = 1;
            else
                w_unsigned_op = 0;
            w_imm_op = 1;
            w_byte_op = 0;
            w_shift_op = 0;
            w_mem_op = 0;
            w_write_op = 0;
            w_branch_op = 0;
            w_jump_op = 0;
            w_nop = 0;
            w_op_type_6 = op_code;
        end
        `LW, `SW, `LUI, `LB, `LBU, `SB:
        begin
            w_alu_op = 0;
            if(op_code ===`LBU)
            w_unsigned_op = 0;
            w_imm_op = 1;
            if(op_code === `LB | op_code === `LBU | op_code === `SB)
                w_byte_op = 1;
            else
                w_byte_op = 0;
            w_shift_op = 0;
            w_mem_op = 1;
            if(op_code === `SW | op_code === `SB)
                w_write_op = 1;
            else
                w_write_op = 0;
            w_branch_op = 0;
            w_jump_op = 0;
            w_nop = 0;
            w_op_type_6 = op_code;
        end
        `J, `JAL, `BEQ, `BNE, `BGTZ, `BLEZ:
        begin
            w_alu_op = 0;
            if(op_code === `J | op_code === `JAL)
                begin
                    w_jump_op = 1;
                    w_imm_op = 1;
                    w_branch_op = 0;
                end
            else
                begin
                    w_jump_op = 0;
                    w_imm_op = 0;
                    w_branch_op = 1;
                end
            w_unsigned_op = 0;
            w_byte_op = 0;
            w_shift_op = 0;
            w_mem_op = 0;
            w_write_op = 0;
            w_nop = 0;
            w_op_type_6 = op_code;
        end
        `REGIMM:
        begin
                w_alu_op = 0;
                w_unsigned_op = 0;
                w_imm_op = 0;
                w_byte_op = 0;
                w_mem_op = 0;
                w_write_op = 0;
                w_shift_op = 0;
                w_jump_op = 0;
            if(w_rt_addr_5 === `BGEZ || w_rt_addr_5 === `BLTZ)
            begin
                w_branch_op = 1;
                w_nop = 0;
                w_op_type_6 = {1'b0, w_rt_addr_5};
            end
            else
                w_branch_op = 0;
                w_nop = 1;
                w_op_type_6 = 6'bx;
        end
        default
        begin
            w_alu_op = 0;
            w_unsigned_op = 0;
            w_imm_op = 0;
            w_byte_op = 0;
            w_mem_op = 0;
            w_write_op = 0;
            w_shift_op = 0;
            w_branch_op = 0;
            w_jump_op = 0;
            w_nop = 1;
            w_op_type_6 = 6'bx;
        end
    endcase
end
endmodule