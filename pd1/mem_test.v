`include "mem.v"
module mem_test;
    reg [31:0] addr, data_in;
    wire [31:0] data_out;
    reg rw, enable;
    reg clock = 1;

    initial begin
        $dumpfile("mem_test.vcd");
        $dumpvars(0, clock);
        $dumpvars(0, addr);
        $dumpvars(0, data_in);
        $dumpvars(0, data_out);
        $dumpvars(0, rw);
        $dumpvars(0, enable);

        #5 enable = 1;
        #15 addr = 32'h0; data_in = 32'hABCDABCD; rw = 0;
        #20 addr = 32'h04; data_in = 32'hDEFADEFA; rw = 0;
        #25 addr = 32'h08; data_in = 32'h12341234; rw = 0;
        #30 rw = 1;
        #35 addr = 32'h0;
        #40 addr = 32'h04;
        #45 addr = 32'h08;
        #50 $finish;
    end

    mem mem_block(.w_data_in_32(data_in),
    .w_data_out_32(data_out),
    .w_addr_32(addr),
    .rw(rw),
    .en(enable),
    .clock(clock));



    always begin
        #2 clock = ~clock;
    end

    always @(posedge clock) begin
        $display("Addr:%h, Data_in:%h, Data_out:%h", addr, data_in, data_out);
    end
endmodule