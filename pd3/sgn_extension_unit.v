module sgn_extension_unit #(parameter INPUT_WIDTH = 16)(
    w_input_x,
    w_output_32
);
input wire [INPUT_WIDTH - 1:0] w_input_x;
output wire [31:0] w_output_32;

assign w_output_32 = {{(32-INPUT_WIDTH){w_input_x[INPUT_WIDTH-1]}}, w_input_x[INPUT_WIDTH-1:0]};
endmodule