module and_assign (x, y, z);
    input wire x, y;
    output wire z;
    assign z = x & y;
endmodule

module reg_and
(
    input wire clock,
    input wire reset,
    input wire in,
    output out
);
reg out;
always @(posedge clock) begin
    if(reset)
        out <= 0;
    else
        out <= in;
end
endmodule

module dut;
    reg x, y, reset;
    reg clock = 1;
    wire z, x_reg, y_reg, out;

    initial begin
        $dumpfile("reg-and.vcd");
        $dumpvars(0, gate);
        $dumpvars(0, reg_gate);

        #0 reset = 1;
        #20 x = 0; y = 0;
         reset <= 0; $display("Reset complete");
        #10 x = 1; y = 1; $display("set 1 1");
        #10 x = 1; y = 0;
        #10 x = 1; y = 1;
        #10 x = 0; y = 1;
        #20 $finish;
    end

    and_assign gate (.x(x_reg), .y(y_reg), .z(z));
    reg_and reg_gate (.clock(clock), .reset(reset), .in(z), .out(out));
    reg_and reg_gate_in_x (.clock(clock), .reset(reset), .in(x), .out(x_reg));
    reg_and reg_gate_in_y (.clock(clock), .reset(reset), .in(y), .out(y_reg));

    always begin
        #5 clock = ~clock;
    end

    always @(posedge clock) begin
        $display("time=%t, reset=%b, x=%b, x_reg=%b, y=%b, y_reg=%b, z=%b, out=%b", $time,reset,x, x_reg, y, y_reg, z, out);
    end
endmodule 