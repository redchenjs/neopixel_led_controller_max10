/*
 * test_ws281x_ctrl.sv
 *
 *  Created on: 2020-07-08 20:23
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_ws281x_ctrl;

logic clk_in;
logic rst_n_in;

logic bit_done_in;

logic        wr_done_in;
logic [31:0] rd_data_in;
logic [ 7:0] tim_sum_in;

logic bit_rdy_out;
logic bit_data_out;

logic       rd_en_out;
logic [5:0] rd_addr_out;

ws281x_ctrl test_ws281x_ctrl(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_done_in(bit_done_in),

    .wr_done_in(wr_done_in),
    .rd_data_in(rd_data_in),
    .tim_sum_in(tim_sum_in),

    .bit_rdy_out(bit_rdy_out),
    .bit_data_out(bit_data_out),

    .rd_en_out(rd_en_out),
    .rd_addr_out(rd_addr_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    bit_done_in <= 1'b0;

    wr_done_in <= 1'b0;
    rd_data_in <= 32'haaaa_cccc;
    tim_sum_in <= 8'h04;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    #11 wr_done_in <= 1'b1;
    #5  wr_done_in <= 1'b0;

    for (integer i=0; i<119; i++) begin
        #50 bit_done_in <= 1'b1;
        #5  bit_done_in <= 1'b0;
    end

    #500 rd_data_in <= 32'h00aa_dddd;

    for (integer i=0; i<119; i++) begin
        #50 bit_done_in <= 1'b1;
        #5  bit_done_in <= 1'b0;
    end

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
