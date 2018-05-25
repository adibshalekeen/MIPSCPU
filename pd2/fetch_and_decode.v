`include "mem.v"
`include "register.v"
module CPU #(parameter PC_BASE_ADDR = 32'h80020000);

//PC signals
reg [31:0] PC = PC_BASE_ADDR;

//instruction memory signals
reg [31:0] instr_mem_addr, instr_mem_data_in;
wire [31:0] instr_mem_data_out;
reg instr_mem_rw, instr_mem_enable = 1;

wire [31:0] w_instr_reg_out_32;
wire [31:0] w_instr_mem_reg_out;
//instruction fetch signals


reg clock = 1;

//test_bench vars
reg [31:0] read_instrs [1000 : 0];
integer counter = 0;
reg hold = 1;
reg writing = 1;

initial begin
    $dumpfile("fetch_and_decode.vcd");
    $dumpvars(0, clock);
    $dumpvars(0, instr_mem_addr);
    $dumpvars(0, instr_mem_data_out);
    $dumpvars(0, instr_mem_data_in);
    $dumpvars(0, PC);
    $dumpvars(0, w_instr_reg_out_32);
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

register_sync #(32) instr_reg_32 (.clock(clock), .reset(instr_reg_reset), .w_in(instr_mem_data_out), .r_out(w_instr_reg_out_32));

//memory population loop
always @(posedge clock) begin
    if(~(read_instrs[counter] === 32'bx))
    begin
        if(~instr_mem_rw)
        begin
            if(hold)
                begin
                    instr_mem_addr = PC - 32'h80020000;
                    PC = PC + 4;
                    instr_mem_data_in = read_instrs[counter];
                    counter = counter + 1;
                    $display("PC: %h, Mem_addr: %h, Data_in: %h, Data_out:%h", PC, instr_mem_addr, instr_mem_data_in, instr_mem_data_out);
                end
                hold = ~hold;
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
        instr_mem_addr = PC - 32'h80020000;
        PC = PC + 4;
        $display("PC: %h, Mem_addr: %h, Data_in: %h, Data_out:%h, Reg_out: %h", PC, instr_mem_addr, instr_mem_data_in, instr_mem_data_out, w_instr_reg_out_32);
    end
end

//clock
always begin
    #5 clock = ~clock;
end

endmodule