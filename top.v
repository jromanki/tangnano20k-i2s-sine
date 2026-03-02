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

    pll pll (
        .clock_in(ext_clk),
        .clock_out(sys_clk),
        .locked()
    );

    wire sys_lrck;
    wire sys_dout;
    wire sys_sync_tick;
    wire sys_bck;
    reg [31:0] data_l;
    reg [31:0] data_r;

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

    reg sync_tick_delayed;
    reg [7:0] sample_cnt;

    always @ (posedge sys_clk) begin
        if (btn) begin
            sample_cnt <= 0;
            data_l <= 32'h0000_0000;
            data_r <= 32'h0000_0000;
            sync_tick_delayed <= 0;
        end
        else begin
            // 1-cycle delayed
            sync_tick_delayed <= sys_sync_tick;
            // rising edge detection
            if (sys_sync_tick && !sync_tick_delayed) begin
                if (sample_cnt < 200 - 1) begin
                    sample_cnt <= sample_cnt + 1;
                end
                else begin
                    // every few sync_ticks flip all bits
                    data_l <= data_l ^ 32'hFFFF_FFFF;
                    data_r <= data_r ^ 32'hFFFF_FFFF;
                    sample_cnt <= 0;
                end
            end
        end
    end

    assign bck = sys_bck;
    assign lrck = sys_lrck;
    assign dout = sys_dout;

endmodule
