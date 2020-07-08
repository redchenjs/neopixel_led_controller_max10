/*
 * test_layer_ctrl.sv
 *
 *  Created on: 2020-07-08 18:52
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_layer_ctrl;

logic clk_in;
logic rst_n_in;

logic dc_in;

logic       byte_rdy_in;
logic [7:0] byte_data_in;

logic [8:0] wr_en_out;
logic       wr_done_out;
logic [5:0] wr_addr_out;
logic [3:0] wr_byte_en_out;

layer_ctrl test_layer_ctrl(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .dc_in(dc_in),

    .byte_rdy_in(byte_rdy_in),
    .byte_data_in(byte_data_in),

    .wr_en_out(wr_en_out),
    .wr_done_out(wr_done_out),
    .wr_addr_out(wr_addr_out),
    .wr_byte_en_out(wr_byte_en_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    dc_in <= 1'b0;

    byte_rdy_in  <= 1'b0;
    byte_data_in <= 8'h00;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    // CONF_WR
    #6 dc_in <= 1'b0;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h2a;
    #5 byte_rdy_in  <= 1'b0;

    // CONF DATA 0: T0H
    #5 dc_in <= 1'b1;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h01;
    #5 byte_rdy_in  <= 1'b0;

    // CONF DATA 1: T0L
    #5 dc_in <= 1'b1;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h12;
    #5 byte_rdy_in  <= 1'b0;

    // CONF DATA 2: T1H
    #5 dc_in <= 1'b1;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h23;
    #5 byte_rdy_in  <= 1'b0;

    // CONF DATA 3: T1L
    #5 dc_in <= 1'b1;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h34;
    #5 byte_rdy_in  <= 1'b0;

    // ADDR_WR
    #5 dc_in <= 1'b0;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h2b;
    #5 byte_rdy_in  <= 1'b0;

    // ADDR DATA
    for (integer i=0; i<64; i++) begin
        #5 dc_in <= 1'b1;
           byte_rdy_in  <= 1'b1;
           byte_data_in <= i;
        #5 byte_rdy_in  <= 1'b0;
    end

    // DATA_WR
    #5 dc_in <= 1'b0;
       byte_rdy_in  <= 1'b1;
       byte_data_in <= 8'h2c;
    #5 byte_rdy_in  <= 1'b0;

    // COLOR DATA
    for (integer i=0; i<1536; i++) begin
        #5 dc_in <= 1'b1;
           byte_rdy_in  <= 1'b1;
           byte_data_in <= i % 8'hff;
        #5 byte_rdy_in  <= 1'b0;
    end

    #75 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
