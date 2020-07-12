/*
 * test_layer_code.sv
 *
 *  Created on: 2020-07-08 21:15
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_layer_code;

logic clk_in;
logic rst_n_in;

logic       wr_en_in;
logic       wr_done_in;
logic [5:0] wr_addr_in;
logic [7:0] wr_data_in;
logic [3:0] wr_byte_en_in;

logic [7:0] t0h_cnt_in;
logic [7:0] t0s_cnt_in;
logic [7:0] t1h_cnt_in;
logic [7:0] t1s_cnt_in;

logic ws281x_code_out;

layer_code test_layer_code(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .wr_en_in(wr_en_in),
    .wr_done_in(wr_done_in),
    .wr_addr_in(wr_addr_in),
    .wr_data_in(wr_data_in),
    .wr_byte_en_in(wr_byte_en_in),

    .t0h_cnt_in(t0h_cnt_in),
    .t0s_cnt_in(t0s_cnt_in),
    .t1h_cnt_in(t1h_cnt_in),
    .t1s_cnt_in(t1s_cnt_in),

    .ws281x_code_out(ws281x_code_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    wr_en_in   <= 1'b0;
    wr_done_in <= 1'b0;
    wr_addr_in <= 8'h00;
    wr_data_in <= 8'h00;
    wr_byte_en_in <= 4'b0000;

    // Unit: 10 ns (2 clk)
    t0h_cnt_in <= 8'h01;
    t0s_cnt_in <= 8'h80;
    t1h_cnt_in <= 8'h7f;
    t1s_cnt_in <= 8'h80;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #11 wr_addr_in <= 8'h00;
        wr_data_in <= 8'h01;
        wr_byte_en_in <= 4'b1000;
        wr_en_in <= 1'b1;
    #5  wr_en_in <= 1'b0;

    #10 wr_data_in <= 8'h00;
        wr_byte_en_in <= 4'b0111;
        wr_en_in <= 1'b1;
    #5  wr_en_in <= 1'b0;

    #10 wr_addr_in <= 8'h01;
        wr_data_in <= 8'h00;
        wr_byte_en_in <= 4'b1000;
        wr_en_in <= 1'b1;
    #5  wr_en_in <= 1'b0;

    #10 wr_data_in <= 8'hff;
        wr_byte_en_in <= 4'b0111;
        wr_en_in <= 1'b1;
    #5  wr_en_in <= 1'b0;

    #10 wr_done_in <= 1'b1;
    #5  wr_done_in <= 1'b0;

    for (integer i=0; i<65536; i++) begin
        #5 wr_done_in <= 1'b1;
        #5 wr_done_in <= 1'b0;
    end

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
