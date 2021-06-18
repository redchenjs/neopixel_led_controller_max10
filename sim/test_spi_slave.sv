/*
 * test_spi_slave.sv
 *
 *  Created on: 2020-07-08 15:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_spi_slave;

logic clk_i;
logic rst_n_i;

logic [7:0] spi_byte_data_i;

logic spi_sclk_i;
logic spi_mosi_i;
logic spi_cs_n_i;

logic spi_miso_o;

logic       spi_byte_vld_o;
logic [7:0] spi_byte_data_o;

spi_slave spi_slave(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .spi_byte_data_i(spi_byte_data_i),

    .spi_sclk_i(spi_sclk_i),
    .spi_mosi_i(spi_mosi_i),
    .spi_cs_n_i(spi_cs_n_i),

    .spi_miso_o(spi_miso_o),

    .spi_byte_vld_o(spi_byte_vld_o),
    .spi_byte_data_o(spi_byte_data_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    spi_byte_data_i <= 8'h6e;

    spi_cs_n_i <= 1'b1;
    spi_sclk_i <= 1'b0;
    spi_mosi_i <= 1'b0;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always @(negedge clk_i) begin
    spi_byte_data_i <= spi_byte_data_i + spi_byte_vld_o;
end

always begin
    #50 spi_cs_n_i <= 1'b0;

    // 0x2A
    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT7
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT6
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT5
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT4
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT3
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT2
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT1
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT0
    #15 spi_sclk_i <= 1'b1;

    // 0x2B
    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT7
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT6
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT5
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT4
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT3
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT2
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT1
    #15 spi_sclk_i <= 1'b1;

    #15 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT0
    #15 spi_sclk_i <= 1'b1;

    for (integer i = 0; i < 1024; i++) begin
        #15 spi_sclk_i <= 1'b0;
            spi_mosi_i <= 1'b0;
        #15 spi_sclk_i <= 1'b1;
    end

    #15 spi_sclk_i <= 1'b0;

    #25 spi_cs_n_i <= 1'b1;

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
