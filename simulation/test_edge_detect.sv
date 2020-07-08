/*
 * test_edge_detect.sv
 *
 *  Created on: 2020-07-08 17:16
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_edge_detect;

logic clk_in;
logic rst_n_in;

logic data_in;

logic pos_edge_out;
logic neg_edge_out;
logic both_edge_out;

edge_detect test_edge_detect(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .data_in(data_in),

    .pos_edge_out(pos_edge_out),
    .neg_edge_out(neg_edge_out),
    .both_edge_out(both_edge_out)
);

initial begin
    clk_in   <= 1'b1;
    rst_n_in <= 1'b0;

    #2 rst_n_in <= 1'b1;
end

always begin
    #2.5 clk_in <= ~clk_in;
end

always begin
    data_in <= 1'b0;

    #12 data_in <= 1'b1;
    #12 data_in <= 1'b0;
    #12 data_in <= 1'b1;
    #12 data_in <= 1'b0;

    #25 rst_n_in <= 1'b0;
    #25 $stop;
end

endmodule
