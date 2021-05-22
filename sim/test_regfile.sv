/*
 * test_regfile.sv
 *
 *  Created on: 2020-07-08 18:23
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_regfile;

logic clk_i;
logic rst_n_i;

logic [2:0] reg_rd_addr_i;

logic       reg_wr_en_i;
logic [2:0] reg_wr_addr_i;
logic [7:0] reg_wr_data_i;

logic [7:0] reg_t0h_time_o;
logic [8:0] reg_t0s_time_o;
logic [7:0] reg_t1h_time_o;
logic [8:0] reg_t1s_time_o;

logic [7:0] reg_chan_len_o;
logic [3:0] reg_chan_cnt_o;

logic [7:0] reg_rd_data_o;

regfile regfile(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .reg_rd_addr_i(reg_rd_addr_i),

    .reg_wr_en_i(reg_wr_en_i),
    .reg_wr_addr_i(reg_wr_addr_i),
    .reg_wr_data_i(reg_wr_data_i),

    .reg_t0h_time_o(reg_t0h_time_o),
    .reg_t0s_time_o(reg_t0s_time_o),
    .reg_t1h_time_o(reg_t1h_time_o),
    .reg_t1s_time_o(reg_t1s_time_o),

    .reg_chan_len_o(reg_chan_len_o),
    .reg_chan_cnt_o(reg_chan_cnt_o),

    .reg_rd_data_o(reg_rd_data_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    reg_rd_addr_i <= 3'h0;

    reg_wr_en_i   <= 1'b0;
    reg_wr_addr_i <= 3'h0;
    reg_wr_data_i <= 8'h00;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #6 reg_rd_addr_i <= reg_rd_addr_i + 1'b1;
end

always begin
    // T0H time (10 ns)
    #6  reg_wr_addr_i <= 3'h0;
        reg_wr_data_i <= 8'h01;
        reg_wr_en_i   <= 1'b1;
    #5  reg_wr_en_i   <= 1'b0;

    // T0L time (10 ns)
    #10 reg_wr_addr_i <= 3'h1;
        reg_wr_data_i <= 8'h12;
        reg_wr_en_i   <= 1'b1;
    #5  reg_wr_en_i   <= 1'b0;

    // T1H time (10 ns)
    #10 reg_wr_addr_i <= 3'h2;
        reg_wr_data_i <= 8'h23;
        reg_wr_en_i   <= 1'b1;
    #5  reg_wr_en_i   <= 1'b0;

    // T1L time (10 ns)
    #10 reg_wr_addr_i <= 3'h3;
        reg_wr_data_i <= 8'h34;
        reg_wr_en_i   <= 1'b1;
    #5  reg_wr_en_i   <= 1'b0;

    // channel length
    #10 reg_wr_addr_i <= 3'h4;
        reg_wr_data_i <= 8'h3f;
        reg_wr_en_i   <= 1'b1;
    #5  reg_wr_en_i   <= 1'b0;

    // channel count
    #10 reg_wr_addr_i <= 3'h5;
        reg_wr_data_i <= 8'h07;
        reg_wr_en_i   <= 1'b1;
    #5  reg_wr_en_i   <= 1'b0;

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
