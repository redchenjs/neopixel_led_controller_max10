/*
 * top.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_led_controller(
    input logic clk_in,      // clk_in = 12 MHz
    input logic rst_n_in,    // rst_n_in, active low

    input logic dc_in,
    input logic spi_sclk_in,
    input logic spi_mosi_in,
    input logic spi_cs_n_in,

    output logic [7:0] ws2812_data_out,

    output logic [7:0] water_led_out,        // Optional, FPS Counter
    output logic [8:0] segment_led_1_out,    // Optional, FPS Counter
    output logic [8:0] segment_led_2_out     // Optional, FPS Counter
);

logic byte_rdy;
logic [7:0] byte_data;

logic frame_rdy;
logic [7:0] wr_en;
logic [5:0] wr_addr;
logic [4:0] byte_en;

logic pll_c0, pll_locked;
logic sys_clk, sys_rst_n;
assign sys_rst_n = pll_locked & rst_n_in;

pll pll(
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

    .byte_rdy_out(byte_rdy),
    .byte_data_out(byte_data)
);

layer_ctl layer_ctl(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .dc_in(dc_in),
    .spi_cs_n_in(spi_cs_n_in),

    .byte_rdy_in(byte_rdy),
    .byte_data_in(byte_data),

    .frame_rdy_out(frame_rdy),

    .wr_en_out(wr_en),
    .wr_addr_out(wr_addr),
    .byte_en_out(byte_en)
);

layer_out layer_out7(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[7]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[7])
);

layer_out layer_out6(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[6]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[6])
);

layer_out layer_out5(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[5]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[5])
);

layer_out layer_out4(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[4]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[4])
);

layer_out layer_out3(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[3]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[3])
);

layer_out layer_out2(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[2]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[2])
);

layer_out layer_out1(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[1]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[1])
);

layer_out layer_out0(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .frame_rdy_in(frame_rdy),

    .wr_en_in(wr_en[0]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .byte_en_in(byte_en),

    .ws2812_data_out(ws2812_data_out[0])
);

pulse_counter fps_counter(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .pulse_in(frame_rdy),

    .water_led_out(water_led_out),
    .segment_led_1_out(segment_led_1_out),
    .segment_led_2_out(segment_led_2_out)
);

endmodule
