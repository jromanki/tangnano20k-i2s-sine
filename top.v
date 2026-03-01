module top #(
    // Num of click cycle per led toggle.
    parameter integer DIV = 100
) (
    input       ext_clk,
    input       btn,
    output      bck,
    output      lrck,
    output      dout
);

    // ---- PLL, 27Mhz -> 180Mhz
    //
    // Generated using the commands:
    //   apio raw -- gowin_pll -d "GW2A-18 C8/I7" -i 27 -o 180 -f pll.v
    //   apio format pll.v
    //
    wire sys_clk;
    wire sys_lrck;
    wire sys_dout;
    wire sys_sync_tick;
    wire sys_bck;
    reg [31:0] data_l;
    reg [31:0] data_r;

    pll pll (
        .clock_in(ext_clk),
        .clock_out(sys_clk),
        .locked()
    );

    i2s_transmit i2s (
        .clk(sys_clk),
        .rst(btn),
        .din_l(data_l),
        .din_r(data_r),

        .bck(sys_bck),
        .lrck(sys_lrck),
        .data(sys_dout),
        .sync_tick(sys_sync_tick)
    );



    assign bck = sys_bck;
    assign lrck = sys_lrck;
    assign dout = sys_dout;

endmodule
