/*
 * test_ws281x_code.sv
 *
 *  Created on: 2020-07-08 20:03
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_ws281x_code;

logic clk_i;
logic rst_n_i;

logic bit_vld_i;
logic bit_data_i;

logic [7:0] t0h_cnt_i;
logic [7:0] t1h_cnt_i;
logic [7:0] tim_cnt_i;

logic bit_rdy_o;
logic bit_code_o;

ws281x_code test_ws281x_code(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_vld_i(bit_vld_i),
    .bit_data_i(bit_data_i),

    .t0h_cnt_i(t0h_cnt_i),
    .t1h_cnt_i(t1h_cnt_i),
    .tim_cnt_i(tim_cnt_i),

    .bit_rdy_o(bit_rdy_o),
    .bit_code_o(bit_code_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    bit_vld_i  <= 1'b0;
    bit_data_i <= 1'b0;

    // Unit: 10 ns (2 clk)
    t0h_cnt_i <= 8'h01;
    t1h_cnt_i <= 8'h02;
    tim_cnt_i <= 8'h03;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #11 bit_vld_i  <= 1'b1;
        bit_data_i <= 1'b0;
    #5  bit_vld_i  <= 1'b0;

    for (integer i=0; i<10; i++) begin
        #25 bit_vld_i  <= 1'b1;
            bit_data_i <= i % 2;
        #5  bit_vld_i  <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
