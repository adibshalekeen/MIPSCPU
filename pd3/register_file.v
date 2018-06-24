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
reg[31:0] reg_file[4:0];

//initialziing register file
assign w_data_s1val_32 = reg_file[w_address_s1_5];
assign w_data_s2val_32 = reg_file[w_address_s2_5];

always @(posedge clock) begin
    if(w_en)
        reg_file[w_address_d_5] = w_data_dval_32;
end
endmodule