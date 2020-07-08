/*
 * test_ws281x_code.sv
 *
 *  Created on: 2020-07-08 20:03
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_ws281x_code;

logic clk_in;
logic rst_n_in;

logic bit_rdy_in;
logic bit_data_in;

logic [7:0] t0h_cnt_in;
logic [7:0] t0l_cnt_in;
logic [7:0] t1h_cnt_in;
logic [7:0] t1l_cnt_in;

logic bit_done_out;
logic bit_code_out;

ws281x_code test_ws281x_code(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_rdy_in(bit_rdy_in),
    .bit_data_in(bit_data_in),

    .t0h_cnt_in(t0h_cnt_in),
    .t0l_cnt_in(t0l_cnt_in),
    .t1h_cnt_in(t1h_cnt_in),
    .t1l_cnt_in(t1l_cnt_in),

    .bit_done_out(bit_done_out),
    .bit_code_out(bit_code_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    bit_rdy_in  <= 1'b0;
    bit_data_in <= 1'b0;

    // Unit: 10 ns (2 clk)
    t0h_cnt_in <= 8'h01;
    t0l_cnt_in <= 8'h02;
    t1h_cnt_in <= 8'h02;
    t1l_cnt_in <= 8'h01;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #11 bit_rdy_in  <= 1'b1;
        bit_data_in <= 1'b0;
    #5  bit_rdy_in  <= 1'b0;

    #50 bit_rdy_in  <= 1'b1;
        bit_data_in <= 1'b1;
    #5  bit_rdy_in  <= 1'b0;

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
