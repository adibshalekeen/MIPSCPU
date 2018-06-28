module register_file
(
    clock,
    w_address_s1_5,
    w_address_s2_5,
    w_address_d_5,
    w_data_dval_32,
    w_data_s1val_32,
    w_data_s2val_32,
    w_en
);
input clock, w_en;
input wire[4:0] w_address_s1_5, w_address_s2_5, w_address_d_5;
input wire[31:0] w_data_dval_32;
output wire[31:0] w_data_s1val_32, w_data_s2val_32;
reg[31:0] reg_file[31:0];
integer k;
initial
begin
    for (k=0; k<32; k=k+1)
    begin
        reg_file[k] = k;
        $display("Register: reg_file%h", reg_file[k]);
    end
end

//initialziing register file
assign w_data_s1val_32 = reg_file[w_address_s1_5];
assign w_data_s2val_32 = reg_file[w_address_s2_5];

/*reg_file[5'b00000] = 32'h0;
reg_file[5'b00001] = 32'h00000001;
reg_file[5'b00010] = 32'h00000002;
reg_file[5'b00011] = 32'h00000003;
reg_file[5'b00100] = 32'h00000004;
reg_file[5'b00101] = 32'h00000005;
reg_file[5'b00110] = 32'h00000006;
reg_file[5'b00111] = 32'h00000007;
reg_file[5'b01000] = 32'h00000008;
reg_file[5'b01001] = 32'h00000009;
reg_file[5'b01010] = 32'h0000000A;
reg_file[5'b01011] = 32'h0000000B;
reg_file[5'b01100] = 32'h0000000C;
reg_file[5'b01101] = 32'h0000000D;
reg_file[5'b01110] = 32'h0000000E;
reg_file[5'b01111] = 32'h0000000F;
reg_file[5'b10000] = 32'h00000010;
reg_file[5'b10001] = 32'h00000020;
reg_file[5'b10010] = 32'h00000030;
reg_file[5'b10011] = 32'h00000040;
reg_file[5'b10100] = 32'h00000050;
reg_file[5'b10101] = 32'h00000060;
reg_file[5'b10110] = 32'h00000070;
reg_file[5'b10111] = 32'h00000080;
reg_file[5'b11000] = 32'h00000090;
reg_file[5'b11001] = 32'h000000A0;
reg_file[5'b11010] = 32'h000000B0;
reg_file[5'b11011] = 32'h000000C0;
reg_file[5'b11100] = 32'h000000D0;
reg_file[5'b11101] = 32'h000000E0;
reg_file[5'b11110] = 32'h000000F0; */

always @(posedge clock) begin
    if(w_en)
    begin
        reg_file[w_address_d_5] = w_data_dval_32;
         $display("Register Write: %h", w_data_dval_32);
    end
    $display("Register: s1:%h, s2:%h, s1 address:%h, s2 address:%h", w_data_s1val_32, w_data_s2val_32, w_address_s1_5, reg_file[5'b00010]);
end
endmodule