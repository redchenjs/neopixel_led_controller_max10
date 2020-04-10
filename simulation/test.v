/*
 * test.v
 *
 *  Created on: 2020-04-10 22:17
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ps / 1ps

module test;

reg clk_in;
reg rst_n_in;

reg dc_in;
reg spi_sclk_in;
reg spi_mosi_in;
reg spi_cs_n_in;

wire [7:0] ws2812_data_out;

ws2812_led_controller test(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .dc_in(dc_in),
    .spi_sclk_in(spi_sclk_in),
    .spi_mosi_in(spi_mosi_in),
    .spi_cs_n_in(spi_cs_n_in),

    .ws2812_data_out(ws2812_data_out)
);

always begin
    clk_in <= 0;
    rst_n_in <= 1;

    dc_in <= 0;
    spi_sclk_in <= 0;
    spi_mosi_in <= 0;
    spi_cs_n_in <= 1;

    #1250 spi_cs_n_in <= 0;

        spi_mosi_in <= 1;  // 0
    #25 spi_mosi_in <= 1;  // 1
    #25 spi_mosi_in <= 0;  // 2
    #25 spi_mosi_in <= 1;  // 3
    #25 spi_mosi_in <= 1;  // 4
    #25 spi_mosi_in <= 0;  // 5
    #25 spi_mosi_in <= 1;  // 6
    #25 spi_mosi_in <= 0;  // 7

    #25 spi_cs_n_in <= 1;

    dc_in <= 1;

    #25 spi_cs_n_in <= 0;

    #200 spi_cs_n_in <= 1;

    $stop;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #12.5 spi_sclk_in <= ~spi_sclk_in;
end

endmodule
