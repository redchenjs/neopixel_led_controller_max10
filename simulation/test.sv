/*
 * test.sv
 *
 *  Created on: 2020-04-10 22:17
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ps / 1ps

module test;

logic clk_in;
logic rst_n_in;

logic dc_in;
logic spi_sclk_in;
logic spi_mosi_in;
logic spi_cs_n_in;

logic [7:0] ws281x_code_out;

ws281x_cube_controller test(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .dc_in(dc_in),
    .spi_sclk_in(spi_sclk_in),
    .spi_mosi_in(spi_mosi_in),
    .spi_cs_n_in(spi_cs_n_in),

    .ws281x_code_out(ws281x_code_out)
);

always begin
    clk_in   <= 1'b0;
    rst_n_in <= 1'b1;

    dc_in       <= 1'b0;
    spi_sclk_in <= 1'b0;
    spi_mosi_in <= 1'b0;
    spi_cs_n_in <= 1'b1;

    #50 spi_cs_n_in <= 1'b0;

        spi_mosi_in <= 1'b1;  // 0
    #25 spi_mosi_in <= 1'b1;  // 1
    #25 spi_mosi_in <= 1'b0;  // 2
    #25 spi_mosi_in <= 1'b1;  // 3
    #25 spi_mosi_in <= 1'b1;  // 4
    #25 spi_mosi_in <= 1'b0;  // 5
    #25 spi_mosi_in <= 1'b1;  // 6
    #25 spi_mosi_in <= 1'b0;  // 7

    #25 spi_cs_n_in <= 1'b1;

    #50 $stop;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #12.5 spi_sclk_in <= ~spi_sclk_in;
end

endmodule
