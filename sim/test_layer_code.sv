/*
 * test_layer_code.sv
 *
 *  Created on: 2020-07-08 21:15
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_layer_code;

logic clk_i;
logic rst_n_i;

logic       wr_en_i;
logic       wr_done_i;
logic [5:0] wr_addr_i;
logic [7:0] wr_data_i;
logic [3:0] wr_byte_en_i;

logic [7:0] t0h_cnt_i;
logic [7:0] t0s_cnt_i;
logic [7:0] t1h_cnt_i;
logic [7:0] t1s_cnt_i;

logic ws281x_code_o;

layer_code test_layer_code(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .wr_en_i(wr_en_i),
    .wr_done_i(wr_done_i),
    .wr_addr_i(wr_addr_i),
    .wr_data_i(wr_data_i),
    .wr_byte_en_i(wr_byte_en_i),

    .t0h_cnt_i(t0h_cnt_i),
    .t0s_cnt_i(t0s_cnt_i),
    .t1h_cnt_i(t1h_cnt_i),
    .t1s_cnt_i(t1s_cnt_i),

    .ws281x_code_o(ws281x_code_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    wr_en_i   <= 1'b0;
    wr_done_i <= 1'b0;
    wr_addr_i <= 8'h00;
    wr_data_i <= 8'h00;
    wr_byte_en_i <= 4'b0000;

    // Unit: 10 ns (2 clk)
    t0h_cnt_i <= 8'h01;
    t0s_cnt_i <= 8'h80;
    t1h_cnt_i <= 8'h7f;
    t1s_cnt_i <= 8'h80;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #11 wr_addr_i <= 8'h00;
        wr_data_i <= 8'h01;
        wr_byte_en_i <= 4'b1000;
        wr_en_i <= 1'b1;
    #5  wr_en_i <= 1'b0;

    #10 wr_data_i <= 8'h00;
        wr_byte_en_i <= 4'b0111;
        wr_en_i <= 1'b1;
    #5  wr_en_i <= 1'b0;

    #10 wr_addr_i <= 8'h01;
        wr_data_i <= 8'h00;
        wr_byte_en_i <= 4'b1000;
        wr_en_i <= 1'b1;
    #5  wr_en_i <= 1'b0;

    #10 wr_data_i <= 8'hff;
        wr_byte_en_i <= 4'b0111;
        wr_en_i <= 1'b1;
    #5  wr_en_i <= 1'b0;

    #10 wr_done_i <= 1'b1;
    #5  wr_done_i <= 1'b0;

    for (integer i=0; i<65536; i++) begin
        #5 wr_done_i <= 1'b1;
        #5 wr_done_i <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
