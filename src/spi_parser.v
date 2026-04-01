module spi_parser (
    input wire clk,
    input wire rst,

	input wire scl,
	input wire mosi,
	input wire cs,

    output wire data_ready,
    output reg [31:0] data_out
);

	wire sys_processing;
	wire sys_is_ready;
	reg sys_spi_reset;
	wire [39:0] sys_recv_data;
	reg sys_data_ready;
	reg sys_data_ready_d1;

	spi_module #(
        .SPI_MASTER(1'b0),
		.INVERT_DATA_ORDER(1'b0),
        .SPI_WORD_LEN(40)
    ) dut (
        .master_clock(clk),
        .SCLK_IN(scl),
        .SS_IN(cs),
        .INPUT_SIGNAL(mosi),
        .data_word_recv(sys_recv_data),
        .processing_word(sys_processing),
        .process_next_word(1'b1), // Keep it armed
        .do_reset(sys_spi_reset),
        .is_ready(sys_is_ready),
        // Unused ports
        .SCLK_OUT(), .SS_OUT(), .OUTPUT_SIGNAL(), .data_word_send(40'h0)
    );



	always @(posedge clk) begin
		if (rst) begin
			sys_spi_reset <= 1'b1;
		end
		else begin
			sys_spi_reset <= 1'b0;
			if (sys_processing == 0) begin
				// data_out <= sys_recv_data[39:8];
				data_out <= sys_recv_data[31:0];
				sys_data_ready <= 1'b1;
			end
			else begin
				sys_data_ready <= 1'b0;
			end

			sys_data_ready_d1 <= sys_data_ready;
		end
	end

	assign data_ready = sys_data_ready_d1;

endmodule