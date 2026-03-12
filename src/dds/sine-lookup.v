module sine_lookup(
    input clk,
    input rst,
    input [10:0] addr,
    output wire [31:0] value
);

    reg [8:0] lookup_addr;
    wire [31:0] prom_data;
    reg [31:0] full_data;
    reg [4:0] counter;

    always @(posedge clk) begin
        if (addr[9]) begin
            lookup_addr[8:0] <= ~addr[8:0];
        end
        else begin
            lookup_addr[8:0] <= addr[8:0];
        end

        counter <= counter + 1;

        if (counter == 15) begin
            if (addr[10]) begin
                full_data <= -prom_data;
            end
            else begin
                full_data <= prom_data;
            end
        end
    end

    wave_rom wave(
        .clk(clk),
        .reset(rst),
        .ad(lookup_addr),
        .data(prom_data)
    );

    assign value = full_data;

endmodule
