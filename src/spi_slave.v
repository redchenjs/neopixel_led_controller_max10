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

reg [2:0] bit_sel;

wire byte_rdy;
assign byte_rdy = (bit_sel == 3'd7) ? 1 : 0;

wire spi_rst_n;
assign spi_rst_n = ~spi_cs_n_in & rst_n_in;

edge2en byte_rdy_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .edge_in(byte_rdy),

    .falling_out(byte_rdy_out)
);

always_ff @(posedge spi_sclk_in or negedge spi_rst_n)
begin
    if (!spi_rst_n) begin
        bit_sel <= 3'h0;
    end else begin
        bit_sel <= bit_sel + 1'b1;

        byte_data_out <= {byte_data_out[6:0], spi_mosi_in};
    end
end

endmodule
