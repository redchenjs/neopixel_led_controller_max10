/*
 * test_ws281x_conf.sv
 *
 *  Created on: 2020-07-10 14:31
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_ws281x_conf;

logic clk_i;
logic rst_n_i;

logic bit_vld_i;
logic bit_data_i;

logic [7:0] t0h_cnt_i;
logic [7:0] t0s_cnt_i;
logic [7:0] t1h_cnt_i;
logic [7:0] t1s_cnt_i;

logic [7:0] tim_cnt_o;

ws281x_conf test_ws281x_conf(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_vld_i(bit_vld_i),
    .bit_data_i(bit_data_i),

    .t0h_cnt_i(t0h_cnt_i),
    .t0s_cnt_i(t0s_cnt_i),
    .t1h_cnt_i(t1h_cnt_i),
    .t1s_cnt_i(t1s_cnt_i),

    .tim_cnt_o(tim_cnt_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    bit_vld_i  <= 1'b0;
    bit_data_i <= 1'b0;

    // Unit: 10 ns (2 clk)
    t0h_cnt_i <= 8'h01;
    t0s_cnt_i <= 8'h80;
    t1h_cnt_i <= 8'hfe;
    t1s_cnt_i <= 8'hff;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #11 bit_vld_i <= 1'b1;
    #5  bit_vld_i <= 1'b0;

    #10 bit_data_i <= 1'b1;

    #10 bit_vld_i <= 1'b1;
    #5  bit_vld_i <= 1'b0;

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
