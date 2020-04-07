/*
 * top.v
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_led_controller(
    input wire clk_in,      // clk_in = 12 MHz
    input wire rst_n_in,    // rst_n_in, active low

    input wire dc_in,
    input wire spi_sclk_in,
    input wire spi_mosi_in,
    input wire spi_cs_n_in,

    output wire [7:0] ws2812_data_out,

    output wire [7:0] water_led_out,        // Optional
    output wire [8:0] segment_led_1_out,    // Optional, FPS Counter
    output wire [8:0] segment_led_2_out     // Optional, FPS Counter
);

supply0 pll_rst;
wire pll_c0, pll_locked;

wire spi_rdy;
wire [7:0] spi_data;

wire data_rdy;
wire [5:0] data_idx;
wire [3:0] byte_sel;
wire [7:0] layer_sel;

wire sys_clk, sys_rst_n;

assign sys_rst_n = pll_locked & rst_n_in;

wire [7:0] fps_count;

assign water_led_out = ~fps_count;

pll pll(
	.areset(pll_rst),
	.inclk0(clk_in),
	.c0(pll_c0),
	.locked(pll_locked)
);

globalclk globalclk(
	.inclk(pll_c0),
	.ena(pll_locked), 
	.outclk(sys_clk)
);

spi_slave spi_slave(
	.clk_in(sys_clk),
    .rst_n_in(sys_rst_n),
    
	.spi_sclk_in(spi_sclk_in),
	.spi_mosi_in(spi_mosi_in),
	.spi_cs_n_in(spi_cs_n_in),
    
    .spi_rdy_out(spi_rdy),
    .spi_data_out(spi_data)
);

layer_ctl layer_ctl(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

	.dc_in(dc_in),
	.spi_rdy_in(spi_rdy),
	.spi_data_in(spi_data),

    .data_rdy_out(data_rdy),
	.data_idx_out(data_idx),
	.byte_sel_out(byte_sel),
    .layer_sel_out(layer_sel)
);

layer_out layer_out0(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[0]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[0])
);

layer_out layer_out1(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[1]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[1])
);

layer_out layer_out2(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[2]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[2])
);

layer_out layer_out3(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[3]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[3])
);

layer_out layer_out4(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[4]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[4])
);

layer_out layer_out5(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[5]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[5])
);

layer_out layer_out6(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[6]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[6])
);

layer_out layer_out7(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

    .layer_en_in(layer_sel[7]),
	.data_rdy_in(data_rdy),
    .data_idx_in(data_idx),
    .byte_sel_in(byte_sel),
	.spi_data_in(spi_data),

	.ws2812_data_out(ws2812_data_out[7])
);

fps_counter fps_counter(
	.clk_in(sys_clk),
	.rst_n_in(sys_rst_n),

	.fps_pulse_in(data_rdy),

	.fps_count_out(fps_count)
);

segment_led segment_led(
	.count(fps_count),

	.segment_led_1(segment_led_1_out),
	.segment_led_2(segment_led_2_out)
);

endmodule
