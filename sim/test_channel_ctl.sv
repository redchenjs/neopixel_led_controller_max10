/*
 * test_channel_ctl.sv
 *
 *  Created on: 2020-07-08 18:52
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_channel_ctl;

logic clk_i;
logic rst_n_i;

logic dc_i;

logic       spi_byte_vld_i;
logic [7:0] spi_byte_data_i;

logic [7:0] reg_chan_len_i;
logic [3:0] reg_chan_cnt_i;

logic [2:0] reg_rd_addr_o;
logic [7:0] reg_rd_data_o;

logic       reg_wr_en_o;
logic [2:0] reg_wr_addr_o;

logic [15:0] ram_wr_en_o;
logic        ram_wr_done_o;
logic  [7:0] ram_wr_addr_o;
logic  [3:0] ram_wr_byte_en_o;

channel_ctl channel_ctl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .dc_i(dc_i),

    .spi_byte_vld_i(spi_byte_vld_i),
    .spi_byte_data_i(spi_byte_data_i),

    .reg_chan_len_i(reg_chan_len_i),
    .reg_chan_cnt_i(reg_chan_cnt_i),

    .reg_rd_addr_o(reg_rd_addr_o),

    .reg_wr_en_o(reg_wr_en_o),
    .reg_wr_addr_o(reg_wr_addr_o),

    .ram_wr_en_o(ram_wr_en_o),
    .ram_wr_done_o(ram_wr_done_o),
    .ram_wr_addr_o(ram_wr_addr_o),
    .ram_wr_byte_en_o(ram_wr_byte_en_o)
);

regfile regfile(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .reg_rd_addr_i(reg_rd_addr_o),

    .reg_wr_en_i(reg_wr_en_o),
    .reg_wr_addr_i(reg_wr_addr_o),
    .reg_wr_data_i(spi_byte_data_i),

    .reg_rd_data_o(reg_rd_data_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    dc_i <= 1'b0;

    spi_byte_vld_i  <= 1'b0;
    spi_byte_data_i <= 8'h00;

    reg_chan_len_i <= 8'h3f;
    reg_chan_cnt_i <= 4'h7;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    // CONF_WR
    #6 dc_i <= 1'b0;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h2a;
    #5 spi_byte_vld_i  <= 1'b0;

    // CONF DATA 0: T0H time (10 ns)
    #5 dc_i <= 1'b1;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h01;
    #5 spi_byte_vld_i  <= 1'b0;

    // CONF DATA 1: T0L time (10 ns)
    #5 dc_i <= 1'b1;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h12;
    #5 spi_byte_vld_i  <= 1'b0;

    // CONF DATA 2: T1H time (10 ns)
    #5 dc_i <= 1'b1;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h23;
    #5 spi_byte_vld_i  <= 1'b0;

    // CONF DATA 3: T1L time (10 ns)
    #5 dc_i <= 1'b1;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h34;
    #5 spi_byte_vld_i  <= 1'b0;

    // CONF DATA 4: channel length
    #5 dc_i <= 1'b1;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h3f;
    #5 spi_byte_vld_i  <= 1'b0;

    // CONF DATA 5: channel count
    #5 dc_i <= 1'b1;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h07;
    #5 spi_byte_vld_i  <= 1'b0;

    // ADDR_WR
    #5 dc_i <= 1'b0;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h2b;
    #5 spi_byte_vld_i  <= 1'b0;

    // ADDR DATA
    for (integer i = 0; i < 512; i++) begin
        #5 dc_i <= 1'b1;
           spi_byte_vld_i  <= 1'b1;
           spi_byte_data_i <= i;
        #5 spi_byte_vld_i  <= 1'b0;
    end

    // DATA_WR
    #5 dc_i <= 1'b0;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h2c;
    #5 spi_byte_vld_i  <= 1'b0;

    // COLOR DATA
    for (integer i = 0; i < 1536; i++) begin
        #5 dc_i <= 1'b1;
           spi_byte_vld_i  <= 1'b1;
           spi_byte_data_i <= i % 8'hff;
        #5 spi_byte_vld_i  <= 1'b0;
    end

    // INFO_RD
    #6 dc_i <= 1'b0;
       spi_byte_vld_i  <= 1'b1;
       spi_byte_data_i <= 8'h3a;
    #5 spi_byte_vld_i  <= 1'b0;

    // DUMMY DATA
    for (integer i = 0; i < 16; i++) begin
        #5 dc_i <= 1'b1;
           spi_byte_vld_i  <= 1'b1;
           spi_byte_data_i <= 1'b0;
        #5 spi_byte_vld_i  <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
