/*****************************
        opcodes
*****************************/
//arithmetic opcodes
`define SPECIAL 6'b0
//rt <- rs + imm
`define ADDIU 6'b001001
//rt <- rs < imm
`define SLTI 6'b001010
`define SLTIU 6'b001011
//rt <- rs or imm
`define ORI 6'b001101
//rt <- rs xor imm
`define XORI 6'b001110

//memory opcodes
//rt <- mem[rs + alu_imm]
`define LW 6'b100011
//mem[rs + alu_imm] <- rt
`define SW 6'b101011
//rt <- alu_imm || 0^16 (load upper 16 of some imm)
//combine this w/ ori to get load imm
`define LUI 6'b001111
//rt <- mem[rs + alu_imm]
`define LB 6'b100000
`define LBU 6'b100100
//mem[rs + alu_imm] <- rt
`define SB 6'b101000

//jump opcodes
//Jump to mem_imm || 32'b0 (branch)
`define J 6'b000010
//Store current PC in lnk reg (GPR31) and jump to mem_imm || 32'b0
`define JAL 6'b000011
//Jump to PC + alu_imm if rs == rt
`define BEQ 6'b000100
//Jump to PC + alu_imm if rs != rt
`define BNE 6'b000101
//Jump to PC + alu_imm if rs > 0
`define BGTZ 6'b000111 
//Jump to PC + alu_imm if rs <= 0
`define BLEZ 6'b000110

`define REGIMM 6'b000001

//
/******************************
        function codes
******************************/
//rd <= rs + rt
`define SPECIAL_ADD 6'b100000
`define SPECIAL_ADDU 6'b100001
//rd <- rs - rt
`define SPECIAL_SUB 6'b100010
`define SPECIAL_SUBU 6'b100011
//{HI, LO} <- rs x rt
`define SPECIAL_MULT 6'b011000
`define SPECIAL_MULTU 6'b011001

//{HI, LO} <- rs / rt
`define SPECIAL_DIV 6'b011010
`define SPECIAL_DIVU 6'b011011
//rd <- HI
`define SPECIAL_MFHI 6'b010000
//rd <- LO
`define SPECIAL_MFLO 6'b010010

//rd <- rs < rt
`define SPECIAL_SLT 6'b101010
`define SPECIAL_SLTU 6'b101011 

//rd <- rt << sa
`define SPECIAL_SLL 6'b000000
//rd <- rt << rs
`define SPECIAL_SLLV 6'b000100
//rd <- rt >> sa
`define SPECIAL_SRL 6'b000010
//rd <- rt >> rs
`define SPECIAL_SRLV 6'b000110
//rd <- rt >> sa (arithmetic)
`define SPECIAL_SRA 6'b000011
//rd <- rt >> rs (arithmetic)
`define SPECIAL_SRAV 6'b000111

//logical operators
`define SPECIAL_AND 6'b100100
`define SPECIAL_OR 6'b100101
`define SPECIAL_XOR 6'b100110
`define SPECIAL_NOR 6'100111

//branch instrs
//Store current PC in rd and jump to rs || 32'b0
`define SPECIAL_JALR 6'b001001
//Jump to rs
`define SPECIAL_JR 6'b001000

//noop
`define SPECIAL_NOP 6'b000000

//Special cases
//Jump to PC + alu_imm if rs >= 0
`define BGEZ 6'b00001
//Jump to PC + alu_imm if rs < 0 
`define BLTZ 6'b00000
