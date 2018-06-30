module mux_221 #(parameter WIDTH=5)(
    w_input0_x,
    w_input1_x,
    w_out_x,
    w_ctrl
);

input wire [WIDTH-1:0] w_input0_x, w_input1_x;
input wire w_ctrl;
output reg [WIDTH-1:0] w_out_x;
reg [WIDTH-1:0] invalid_state = {(WIDTH-1){1'bX}};
always @(*) begin
    if(w_ctrl)
        w_out_x = w_input1_x;
    else if(~w_ctrl)
        w_out_x = w_input0_x;
    else 
        w_out_x = invalid_state;
end

endmodule