module 221_mux(# WIDTH=5)(
    w_input0_x,
    w_input1_x,
    w_out_x,
    w_ctrl
);

input wire [WIDTH-1:0] w_input0_x, w_input1_x;
input wire w_ctrl;
output reg [WIDTH-1:0] w_out_x;

always @(w_ctrl) begin
    if(w_ctrl)
        w_out_x = w_input1_x;
    else
        w_out_x = w_input0_x;
  endcase
end

endmodule