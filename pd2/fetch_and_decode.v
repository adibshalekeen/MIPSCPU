`include "mem.v"
`include "register.v"
`include "decoder.v"
module CPU #(parameter PC_BASE_ADDR = 32'h80020000);

//PC signals
reg [31:0] PC = PC_BASE_ADDR;

//instruction memory signals
reg [31:0] instr_mem_addr, instr_mem_data_in;
wire [31:0] instr_mem_data_out;
reg instr_mem_rw, instr_mem_enable = 1;

wire [31:0] r_instr_reg_out_32;
wire [31:0] w_instr_mem_reg_out;

//decoder signals
wire w_alu_op;
wire w_mem_op;
wire w_branch_op;
wire w_nop;
wire [15:0] w_alu_imm_16;
wire [25:0] w_mem_imm_26;
wire [5:0] w_op_type_6;
wire [4:0] w_rs_5;
wire [4:0] w_rt_5;
wire [4:0] w_rd_5;
wire [4:0] w_sh_5;
wire [5:0] w_func_6;
wire [31:0] w_decoder_instr_out;
//test_bench vars
reg [31:0] read_instrs [1000 : 0];
integer counter = 0;
reg writing = 1;
reg clock = 1;

initial begin
    $dumpfile("fetch_and_decode.vcd");
    $dumpvars(0, clock);
    $dumpvars(0, instr_mem_addr);
    $dumpvars(0, instr_mem_data_out);
    $dumpvars(0, instr_mem_data_in);
    $dumpvars(0, PC);
    $dumpvars(0, r_instr_reg_out_32);
    $dumpvars(0, instr_mem_rw);

    $readmemh("mips-benchmarks/add.x", read_instrs);
    PC = PC_BASE_ADDR;
    instr_mem_rw = 0;
    instr_mem_enable = 1;
    #1000 $finish;
end

mem instruction_memory(.w_data_in_32(instr_mem_data_in),
.w_data_out_32(instr_mem_data_out),
.w_addr_32(instr_mem_addr),
.rw(instr_mem_rw),
.en(instr_mem_enable),
.clock(clock));

decoder instruction_decoder(.clock(clock),
.w_instr_32(r_instr_reg_out_32),
.w_instr_out_32(w_decoder_instr_out),
.w_alu_op(w_alu_op),
.w_mem_op(w_mem_op),
.w_branch_op(w_branch_op),
.w_nop(w_nop),
.w_alu_imm_val_16(w_alu_imm_16),
.w_branch_imm_val_26(w_mem_imm_26),
.w_op_type_6(w_op_type_6),
.w_rs_addr_5(w_rs_5),
.w_rt_addr_5(w_rt_5),
.w_rd_addr_5(w_rd_5),
.w_sh_amt_5(w_sh_5),
.w_func_6(w_func_6));

register_sync #(32) instr_reg_32 (.clock(clock), .reset(instr_reg_reset), .w_in(instr_mem_data_out), .w_out(r_instr_reg_out_32));


//memory population loop
always @(posedge clock) begin
    if(~(read_instrs[counter] === 32'bx))
    begin
        if(~instr_mem_rw)
        begin
#1          instr_mem_addr = PC - 32'h80020000;
            PC = PC + 4;
            instr_mem_data_in = read_instrs[counter];
            counter = counter + 1;
            $display("PC: %h, Mem_addr: %h, Data_in: %h, Data_out:%h", PC, instr_mem_addr, instr_mem_data_in, instr_mem_data_out);
        end
    end
    else
        begin
            if(writing)
                begin
                    PC = PC_BASE_ADDR;
                    writing = 0;
                    instr_mem_rw = 1;
                    $display("Resetting... PC:%h", PC);
                end
        end
end

//fetch loop
always @(posedge clock) begin
    if(~writing)
    begin
     #1 instr_mem_addr = PC - 32'h80020000;
        PC = PC + 4;
        $display("PC: %h, Mem_addr: %h, Data_in: %h, Data_out:%h, Reg_out: %h", PC, instr_mem_addr, instr_mem_data_in, instr_mem_data_out, r_instr_reg_out_32);
    end
end

//clock
always begin
    #5 clock = ~clock;
end

endmodule