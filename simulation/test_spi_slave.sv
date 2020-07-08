/*
 * test_spi_slave.sv
 *
 *  Created on: 2020-07-08 15:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_spi_slave;

logic clk_in;
logic rst_n_in;

logic spi_sclk_in;
logic spi_mosi_in;
logic spi_cs_n_in;

logic       byte_rdy_out;
logic [7:0] byte_data_out;

spi_slave test_spi_slave(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .spi_sclk_in(spi_sclk_in),
    .spi_mosi_in(spi_mosi_in),
    .spi_cs_n_in(spi_cs_n_in),

    .byte_rdy_out(byte_rdy_out),
    .byte_data_out(byte_data_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    // SPI Mode: CPOL=0, CPHA=0, MSB First
    spi_cs_n_in <= 1'b1;
    spi_sclk_in <= 1'b0;
    spi_mosi_in <= 1'b0;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #50 spi_cs_n_in <= 1'b0;

    // 0x2A
    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT7
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT6
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT5
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT4
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT3
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT2
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT1
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT0
    #12 spi_sclk_in <= 1'b1;

    // 0x2B
    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT7
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT6
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT5
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT4
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT3
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b0;  // BIT2
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT1
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;
        spi_mosi_in <= 1'b1;  // BIT0
    #12 spi_sclk_in <= 1'b1;

    #12 spi_sclk_in <= 1'b0;

    #25 spi_cs_n_in <= 1'b1;

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
