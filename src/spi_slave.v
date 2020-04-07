/*
 * spi_slave.v
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module spi_slave(
    input wire clk_in,
    input wire rst_n_in,

    input wire spi_sclk_in,
    input wire spi_mosi_in,
    input wire spi_cs_n_in,

    output wire byte_rdy_out,
    output wire [7:0] byte_data_out
);

reg	[3:0] bit_cnt;

reg	[1:0] byte_pul;
reg	[1:0] byte_rdy_pul;
assign byte_rdy_out = byte_rdy_pul[0] & ~byte_rdy_pul[1];  // Rising Edge Pulse

wire spi_rst_n;
assign spi_rst_n = ~spi_cs_n_in & rst_n_in;

always @(posedge spi_sclk_in or negedge spi_rst_n)
begin
    if (!spi_rst_n) begin
        bit_cnt <= 4'h0;
    end else begin
        bit_cnt <= bit_cnt + 1'b1;

        if (bit_cnt[3]) begin
            bit_cnt[3] <= 1'b0;
        end

        byte_data_out <= {byte_data_out[6:0], spi_mosi_in};
    end
end

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        byte_pul <= 2'b00;
    end else begin
        byte_pul[0] <= bit_cnt[3];
        byte_pul[1] <= byte_pul[0];
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        byte_rdy_pul <= 2'b00;
    end else begin
        byte_rdy_pul[0] <= byte_pul[1];
        byte_rdy_pul[1] <= byte_rdy_pul[0];
    end
end

endmodule
