/*
 * layer_out.v
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_out(
	input wire clk_in,
	input wire rst_n_in,

    input wire layer_en_in,
	input wire data_rdy_in,
    input wire [5:0] data_idx_in,
	input wire [3:0] byte_sel_in,
    input wire [7:0] spi_data_in,

	output wire ws2812_data_out
);

wire ram_rd_en;
wire [5:0] ram_rd_addr;
wire [5:0] ram_wr_addr;
wire [31:0] ram_data;

wire bit_rdy, bit_done, bit_data;

idx2addr idx2addr(
    .clk_in(clk_in),
	.rst_n_in(rst_n_in),
	.idx_in(data_idx_in),
	.addr_out(ram_wr_addr)
);

ram64 ram64(
	.byteena_a(byte_sel_in),
	.clock(clk_in),
	.data({spi_data_in, spi_data_in, spi_data_in, spi_data_in}),
	.rdaddress(ram_rd_addr),
	.rden(ram_rd_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en_in),
	.q(ram_data)
);

ws2812_ctl ws2812_ctl(
	.clk_in(clk_in),
	.rst_n_in(rst_n_in),

	.bit_done_in(bit_done),
    .ram_rd_en_in(data_rdy_in),
	.ram_data_in(ram_data),

    .bit_rdy_out(bit_rdy),
    .bit_data_out(bit_data),
    .ram_rd_en_out(ram_rd_en),
    .ram_rd_addr_out(ram_rd_addr)
);

ws2812_out ws2812_out(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),	

    .bit_rdy_in(bit_rdy),
    .bit_data_in(bit_data),

    .bit_done_out(bit_done),
    .ws2812_data_out(ws2812_data_out)
);

endmodule
