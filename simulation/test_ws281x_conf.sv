/*
 * test_ws281x_conf.sv
 *
 *  Created on: 2020-07-10 14:31
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_ws281x_conf;

logic clk_in;
logic rst_n_in;

logic bit_rdy_in;
logic bit_data_in;

logic [7:0] t0h_cnt_in;
logic [7:0] t0s_cnt_in;
logic [7:0] t1h_cnt_in;
logic [7:0] t1s_cnt_in;

logic [7:0] tim_sum_out;

ws281x_conf test_ws281x_conf(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_rdy_in(bit_rdy_in),
    .bit_data_in(bit_data_in),

    .t0h_cnt_in(t0h_cnt_in),
    .t0s_cnt_in(t0s_cnt_in),
    .t1h_cnt_in(t1h_cnt_in),
    .t1s_cnt_in(t1s_cnt_in),

    .tim_sum_out(tim_sum_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    bit_rdy_in  <= 1'b0;
    bit_data_in <= 1'b0;

    // Unit: 10 ns (2 clk)
    t0h_cnt_in <= 8'h01;
    t0s_cnt_in <= 8'h80;
    t1h_cnt_in <= 8'hfe;
    t1s_cnt_in <= 8'hff;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #11 bit_rdy_in <= 1'b1;
    #5  bit_rdy_in <= 1'b0;

    #10 bit_data_in <= 1'b1;

    #10 bit_rdy_in <= 1'b1;
    #5  bit_rdy_in <= 1'b0;

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
