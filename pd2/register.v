module register_sync #(parameter WIDTH = 32)
(
    clock,
    reset,
    w_in,
    r_out
);
input wire clock, reset;
input wire[WIDTH-1:0] w_in;
output reg[WIDTH-1:0] r_out;
always @(posedge clock) begin
    if(reset)
        r_out <= 32'h0;
    else
        r_out <= w_in;
end
endmodule