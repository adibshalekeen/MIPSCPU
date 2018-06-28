module sgn_extension_unit_32b(
    w_input_16,
    w_output_32
);
input wire [15:0] w_input_16;
output wire [31:0] w_output_32;

assign w_output_32 = { {16{w_input_16[7]}}, w_input_16[7:0] };
endmodule