// module sine_lookup(
//     input clk,
//     input rst,
//     input load_tick,
//     input [31:0] phase_inc,
//     output wire [31:0] value
// );

//     sine_dds sine_dds(
//         .clk(sys_clk),
//         .rst(btn),
//         .addr(sample_cnt),
//         .value(sample)
//     );

//     reg phase_acc[31:0]

//     always @ (posedge sys_clk) begin

//         /* make dac_ready detect rising edge of sync_tick */
//         sync_tick_last <= sys_sync_tick;
//         dac_ready <= (sys_sync_tick && !sync_tick_last);

//         if (rst) begin
//             sample_cnt <= 0;
//             sync_tick_last <= 0;
//             dac_ready <= 0;
//         end
//         else begin
//             /* if both words have been transmitted dac_ready = 1
//                 for 1 sys_clk cycle */
//             if (dac_ready) begin
//                 data_l <= sample;
//                 data_r <= sample;
//                 sample_cnt <= sample_cnt + 1;
//             end
//         end
//     end

//     always @ (posedge clk) begin

//         if (btn) begin
//             phase_acc <= 0;
//         end
//         else begin
//             if (tick) begin
//                 data_l <= sample;
//                 data_r <= sample;
//                 sample_cnt <= sample_cnt + 1;
//             end
//         end
//     end

// endmodule