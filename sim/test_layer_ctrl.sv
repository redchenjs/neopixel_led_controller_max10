/*
 * test_layer_ctrl.sv
 *
 *  Created on: 2020-07-08 18:52
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_layer_ctrl;

logic clk_i;
logic rst_n_i;

logic dc_i;

logic       byte_vld_i;
logic [7:0] byte_data_i;

logic [8:0] wr_en_o;
logic       wr_done_o;
logic [5:0] wr_addr_o;
logic [3:0] wr_byte_en_o;

layer_ctrl test_layer_ctrl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .dc_i(dc_i),

    .byte_vld_i(byte_vld_i),
    .byte_data_i(byte_data_i),

    .wr_en_o(wr_en_o),
    .wr_done_o(wr_done_o),
    .wr_addr_o(wr_addr_o),
    .wr_byte_en_o(wr_byte_en_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    dc_i <= 1'b0;

    byte_vld_i  <= 1'b0;
    byte_data_i <= 8'h00;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    // CONF_WR
    #6 dc_i <= 1'b0;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h2a;
    #5 byte_vld_i  <= 1'b0;

    // CONF DATA 0: T0H
    #5 dc_i <= 1'b1;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h01;
    #5 byte_vld_i  <= 1'b0;

    // CONF DATA 1: T0L
    #5 dc_i <= 1'b1;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h12;
    #5 byte_vld_i  <= 1'b0;

    // CONF DATA 2: T1H
    #5 dc_i <= 1'b1;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h23;
    #5 byte_vld_i  <= 1'b0;

    // CONF DATA 3: T1L
    #5 dc_i <= 1'b1;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h34;
    #5 byte_vld_i  <= 1'b0;

    // ADDR_WR
    #5 dc_i <= 1'b0;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h2b;
    #5 byte_vld_i  <= 1'b0;

    // ADDR DATA
    for (integer i=0; i<64; i++) begin
        #5 dc_i <= 1'b1;
           byte_vld_i  <= 1'b1;
           byte_data_i <= i;
        #5 byte_vld_i  <= 1'b0;
    end

    // DATA_WR
    #5 dc_i <= 1'b0;
       byte_vld_i  <= 1'b1;
       byte_data_i <= 8'h2c;
    #5 byte_vld_i  <= 1'b0;

    // COLOR DATA
    for (integer i=0; i<1536; i++) begin
        #5 dc_i <= 1'b1;
           byte_vld_i  <= 1'b1;
           byte_data_i <= i % 8'hff;
        #5 byte_vld_i  <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
