module data_mem #(parameter MEM_DEPTH = 1000000)(
    w_data_in_32,
    w_addr_32,
    w_write_op,
    w_en,
    w_byte_op,
    clock,
    w_data_out_32,
    w_data_out_8
);

reg[7:0] memory_block[MEM_DEPTH : 0];

input wire w_write_op, w_en, w_byte_op, clock;
input wire [31:0] w_addr_32;
input wire [31:0] w_data_in_32;
output wire [31:0] w_data_out_32;
output wire [7:0] w_data_out_8;

assign w_data_out_8 = memory_block[w_translated_waddr];
assign w_data_out_32 = {memory_block[w_translated_waddr], memory_block[w_translated_waddr + 1], memory_block[w_translated_waddr + 2], memory_block[w_translated_waddr + 3]};

wire [31:0] w_translated_waddr;

assign w_translated_waddr = w_addr_32 - 32'h80020000;
always @(posedge clock) begin
    if(w_en && w_write_op)
    begin
        if(w_byte_op)
            memory_block[w_translated_waddr] = w_data_in_32[7:0];
        else
            begin
                memory_block[w_translated_waddr + 3] = w_data_in_32[7:0];
                memory_block[w_translated_waddr + 2] = w_data_in_32[15:8];
                memory_block[w_translated_waddr + 1] = w_data_in_32[23:16];
                memory_block[w_translated_waddr] = w_data_in_32[31:24];
            end
    $display("Memory addr: %d data: %d",w_translated_waddr, w_data_in_32);
    end
end

endmodule