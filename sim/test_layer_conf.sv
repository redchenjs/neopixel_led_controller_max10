/*
 * test_layer_conf.sv
 *
 *  Created on: 2020-07-08 18:23
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_layer_conf;

logic clk_i;
logic rst_n_i;

logic       wr_en_i;
logic [5:0] wr_addr_i;
logic [7:0] wr_data_i;

logic [7:0] t0h_cnt_o;
logic [7:0] t0s_cnt_o;
logic [7:0] t1h_cnt_o;
logic [7:0] t1s_cnt_o;

layer_conf test_layer_conf(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .wr_en_i(wr_en_i),
    .wr_addr_i(wr_addr_i),
    .wr_data_i(wr_data_i),

    .t0h_cnt_o(t0h_cnt_o),
    .t0s_cnt_o(t0s_cnt_o),
    .t1h_cnt_o(t1h_cnt_o),
    .t1s_cnt_o(t1s_cnt_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    wr_en_i   <= 1'b0;
    wr_addr_i <= 6'h00;
    wr_data_i <= 8'h00;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    // T0H
    #6  wr_addr_i <= 6'h00;
        wr_data_i <= 8'h01;
        wr_en_i   <= 1'b1;
    #5  wr_en_i   <= 1'b0;

    // T0L
    #10 wr_addr_i <= 6'h01;
        wr_data_i <= 8'h12;
        wr_en_i   <= 1'b1;
    #5  wr_en_i   <= 1'b0;

    // T1H
    #10 wr_addr_i <= 6'h02;
        wr_data_i <= 8'h23;
        wr_en_i   <= 1'b1;
    #5  wr_en_i   <= 1'b0;

    // T1L
    #10 wr_addr_i <= 6'h03;
        wr_data_i <= 8'h34;
        wr_en_i   <= 1'b1;
    #5  wr_en_i   <= 1'b0;

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
