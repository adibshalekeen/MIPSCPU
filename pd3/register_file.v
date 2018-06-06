module register_file
(
    clock,
    w_address_s1_5,
    w_address_s2_5,
    w_address_d_5,
    w_data_dval_32,
    w_data_s1val_32,
    w_data_s2val_32,
    w_write_enable
);
input clock, w_write_enable;
input wire[4:0] w_address_s1_5, w_address_s2_5, w_address_d_5;
input wire[31:0] w_data_dval_32;
output wire[31:0] w_data_s1val_32, w_data_s2val_32;
reg[31:0] reg_file[4:0];

reg_file[0] = 32'd0;
reg_file[1] = 32'd1;
reg_file[2] = 32'd2;
reg_file[3] = 31'd3;

reg_file[4] = 32'd4;
reg_file[5] = 32'd5;
reg_file[6] = 32'd6;
reg_file[7] = 31'd7;

reg_file[8] = 32'd8;
reg_file[9] = 32'd9;
reg_file[10] = 32'd10;
reg_file[11] = 31'd11;

reg_file[12] = 32'd12;
reg_file[13] = 32'd13;
reg_file[14] = 32'd14;
reg_file[15] = 31'd15;

reg_file[16] = 32'd16;
reg_file[17] = 32'd17;
reg_file[18] = 32'd18;
reg_file[19] = 31'd19;

reg_file[20] = 32'd20;
reg_file[21] = 32'd21;
reg_file[22] = 32'd22;
reg_file[23] = 31'd23;

reg_file[24] = 32'd24;
reg_file[25] = 32'd25;
reg_file[26] = 32'd26;
reg_file[27] = 31'd27;

reg_file[28] = 32'd28;
reg_file[29] = 32'd29;
reg_file[30] = 32'd30;
reg_file[31] = 31'd31;

assign w_data_s1val_32 = reg_file[w_address_s1_5];
assign w_data_s2val_32 = reg_file[w_address_s2_5];

always @(posedge clock) begin
    if(w_write_enable)
    begin
        reg_file[w_address_d_5] = w_data_dval_32;
    end
end
endmodule