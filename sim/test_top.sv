/*
 * test_top.sv
 *
 *  Created on: 2021-05-22 14:11
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_top;

logic clk_i;
logic rst_n_i;

logic dc_i;

logic spi_sclk_i;
logic spi_mosi_i;
logic spi_cs_n_i;

logic spi_miso_o;

logic       spi_byte_vld;
logic [7:0] spi_byte_data;

logic [2:0] reg_rd_addr;
logic [7:0] reg_rd_data;

logic       reg_wr_en;
logic [2:0] reg_wr_addr;

spi_slave spi_slave(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .spi_byte_data_i(reg_rd_data),

    .spi_sclk_i(spi_sclk_i),
    .spi_mosi_i(spi_mosi_i),
    .spi_cs_n_i(spi_cs_n_i),

    .spi_miso_o(spi_miso_o),

    .spi_byte_vld_o(spi_byte_vld),
    .spi_byte_data_o(spi_byte_data)
);

channel_ctl channel_ctl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .dc_i(dc_i),

    .spi_byte_vld_i(spi_byte_vld),
    .spi_byte_data_i(spi_byte_data),

    .reg_rd_addr_o(reg_rd_addr),

    .reg_wr_en_o(reg_wr_en),
    .reg_wr_addr_o(reg_wr_addr)
);

regfile regfile(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .reg_rd_addr_i(reg_rd_addr),

    .reg_wr_en_i(reg_wr_en),
    .reg_wr_addr_i(reg_wr_addr),
    .reg_wr_data_i(spi_byte_data),

    .reg_rd_data_o(reg_rd_data)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    dc_i <= 1'b0;

    spi_cs_n_i <= 1'b1;
    spi_sclk_i <= 1'b0;
    spi_mosi_i <= 1'b0;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #50 spi_cs_n_i <= 1'b0;

    // CONF_WR
    #12 dc_i <= 1'b0;

    // 0x2A
    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT7
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT6
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT5
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT4
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT3
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT2
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT1
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT0
    #12 spi_sclk_i <= 1'b1;

    #12 dc_i <= 1'b1;

    for (integer i = 0; i < 80; i++) begin
        #12 spi_sclk_i <= 1'b0;
            spi_mosi_i <= 1'b1;
        #12 spi_sclk_i <= 1'b1;
    end

    // CONF_RD
    #12 dc_i <= 1'b0;

    // 0x2D
    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT7
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT6
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT5
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT4
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT3
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT2
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b0;  // BIT1
    #12 spi_sclk_i <= 1'b1;

    #12 spi_sclk_i <= 1'b0;
        spi_mosi_i <= 1'b1;  // BIT0
    #12 spi_sclk_i <= 1'b1;

    #12 dc_i <= 1'b1;

    for (integer i = 0; i < 80; i++) begin
        #12 spi_sclk_i <= 1'b0;
            spi_mosi_i <= 1'b0;
        #12 spi_sclk_i <= 1'b1;
    end

    #12 dc_i <= 1'b0;

    #12 spi_sclk_i <= 1'b0;

    #25 spi_cs_n_i <= 1'b1;

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
