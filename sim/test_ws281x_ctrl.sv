/*
 * test_ws281x_ctrl.sv
 *
 *  Created on: 2020-07-08 20:23
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_ws281x_ctrl;

logic clk_i;
logic rst_n_i;

logic bit_rdy_i;

logic        wr_done_i;
logic [31:0] rd_data_i;
logic [ 7:0] tim_cnt_i;

logic bit_vld_o;
logic bit_data_o;

logic       rd_en_o;
logic [5:0] rd_addr_o;

ws281x_ctrl test_ws281x_ctrl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_rdy_i(bit_rdy_i),

    .wr_done_i(wr_done_i),
    .rd_data_i(rd_data_i),
    .tim_cnt_i(tim_cnt_i),

    .bit_vld_o(bit_vld_o),
    .bit_data_o(bit_data_o),

    .rd_en_o(rd_en_o),
    .rd_addr_o(rd_addr_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    bit_rdy_i <= 1'b0;

    wr_done_i <= 1'b0;
    rd_data_i <= 32'haaaa_cccc;
    tim_cnt_i <= 8'h04;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #11 wr_done_i <= 1'b1;
    #5  wr_done_i <= 1'b0;

    for (integer i=0; i<119; i++) begin
        #50 bit_rdy_i <= 1'b1;
        #5  bit_rdy_i <= 1'b0;
    end

    #500 rd_data_i <= 32'h00aa_dddd;

    for (integer i=0; i<119; i++) begin
        #50 bit_rdy_i <= 1'b1;
        #5  bit_rdy_i <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
