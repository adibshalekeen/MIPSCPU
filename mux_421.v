module mux_421 #(parameter WIDTH=5)(
    w_input00_x,
    w_input01_x,
    w_input10_x,
    w_input11_x,
    w_out_x,
    w_ctrl_2
);

input wire [WIDTH-1:0] w_input00_x, w_input01_x, w_input10_x, w_input11_x;
input wire [1:0] w_ctrl_2;
output reg [WIDTH-1:0] w_out_x;

always @(*) begin
  case(w_ctrl_2)
  2'b00: w_out_x = w_input00_x;
  2'b01: w_out_x = w_input01_x;
  2'b10: w_out_x = w_input10_x;
  2'b11: w_out_x = w_input11_x;
  endcase
end

endmodule