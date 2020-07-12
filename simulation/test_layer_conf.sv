/*
 * test_layer_conf.sv
 *
 *  Created on: 2020-07-08 18:23
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_layer_conf;

logic clk_in;
logic rst_n_in;

logic       wr_en_in;
logic [5:0] wr_addr_in;
logic [7:0] wr_data_in;

logic [7:0] t0h_cnt_out;
logic [7:0] t0s_cnt_out;
logic [7:0] t1h_cnt_out;
logic [7:0] t1s_cnt_out;

layer_conf test_layer_conf(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .wr_en_in(wr_en_in),
    .wr_addr_in(wr_addr_in),
    .wr_data_in(wr_data_in),

    .t0h_cnt_out(t0h_cnt_out),
    .t0s_cnt_out(t0s_cnt_out),
    .t1h_cnt_out(t1h_cnt_out),
    .t1s_cnt_out(t1s_cnt_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    wr_en_in   <= 1'b0;
    wr_addr_in <= 6'h00;
    wr_data_in <= 8'h00;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    // T0H
    #6  wr_addr_in <= 6'h00;
        wr_data_in <= 8'h01;
        wr_en_in   <= 1'b1;
    #5  wr_en_in   <= 1'b0;

    // T0L
    #10 wr_addr_in <= 6'h01;
        wr_data_in <= 8'h12;
        wr_en_in   <= 1'b1;
    #5  wr_en_in   <= 1'b0;

    // T1H
    #10 wr_addr_in <= 6'h02;
        wr_data_in <= 8'h23;
        wr_en_in   <= 1'b1;
    #5  wr_en_in   <= 1'b0;

    // T1L
    #10 wr_addr_in <= 6'h03;
        wr_data_in <= 8'h34;
        wr_en_in   <= 1'b1;
    #5  wr_en_in   <= 1'b0;

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
