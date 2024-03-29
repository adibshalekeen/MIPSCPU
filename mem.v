
module mem #(parameter MEM_DEPTH = 250000)(
    w_data_in_32,
    w_data_out_32,
    w_addr_32,
    rw,
    en,
    clock    
);

reg[7:0] memory_block[MEM_DEPTH : 0];

input wire[31:0] w_data_in_32;
input wire[31:0] w_addr_32;
wire [31:0] translated_addr;
assign translated_addr = w_addr_32 - 32'h80020000;
input clock, rw, en;

output wire[31:0] w_data_out_32;

assign w_data_out_32 = {memory_block[translated_addr], memory_block[translated_addr + 1], memory_block[translated_addr + 2], memory_block[translated_addr + 3]};

always @(posedge clock) begin
    if(en)
    begin
        if(~rw)
        begin
            memory_block[translated_addr + 3] = w_data_in_32[7:0];
            memory_block[translated_addr + 2] = w_data_in_32[15:8];
            memory_block[translated_addr + 1] = w_data_in_32[23:16];
            memory_block[translated_addr] = w_data_in_32[31:24];
        end
    end
end
endmodule