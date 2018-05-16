`include "mem.v"
module mem_test #(parameter LOCAL_MEM_SIZE = 27);
    reg [31:0] addr, data_in;
    wire [31:0] data_out;
    reg rw, enable;
    reg clock = 1;

    reg [31:0] local_mem [0:LOCAL_MEM_SIZE];
    
    integer counter = 0;
    initial begin
        $dumpfile("mem_test.vcd");
        $dumpvars(0, clock);
        $dumpvars(0, addr);
        $dumpvars(0, data_in);
        $dumpvars(0, data_out);
        $dumpvars(0, rw);
        $dumpvars(0, enable);

     /* 
        Basic functionality test
        #5 enable = 1;
        #15 addr = 32'h0; data_in = 32'hABCDABCD; rw = 0;
        #20 addr = 32'h04; data_in = 32'hDEFADEFA; rw = 0;
        #25 addr = 32'h08; data_in = 32'h12341234; rw = 0;
        #30 rw = 1;
        #35 addr = 32'h0;
        #40 addr = 32'h04;
        #45 addr = 32'h08;*/

        //large scale binary loading test
        
        rw = 0;        
        $readmemh("data.x", local_mem);
        $display("GOT: %d", local_mem[0]);
        #5 enable = 1;
        #300  $finish;
    end

    mem mem_block(.w_data_in_32(data_in),
    .w_data_out_32(data_out),
    .w_addr_32(addr),
    .rw(rw),
    .en(enable),
    .clock(clock));

    always @(posedge clock) begin
        if(~(local_mem[counter]) == 32'hx) 
        begin
            addr = counter;
            data_in = local_mem[counter];
            counter = counter + 4;
        end
        else
            rw = 1;
    end
        
    always begin
        #2 clock = ~clock;
    end

    always @(posedge clock) begin
        $display("Addr:%h, Data_in:%h, Data_out:%h", addr, data_in, data_out);
    end
endmodule