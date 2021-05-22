/*
 * test_edge2en.sv
 *
 *  Created on: 2020-07-08 17:16
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_edge2en;

logic clk_i;
logic rst_n_i;

logic data_i;

logic pos_edge_o;
logic neg_edge_o;
logic any_edge_o;

edge2en edge2en(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .data_i(data_i),

    .pos_edge_o(pos_edge_o),
    .neg_edge_o(neg_edge_o),
    .any_edge_o(any_edge_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    data_i <= 1'b0;

    #12 data_i <= 1'b1;
    #12 data_i <= 1'b0;
    #12 data_i <= 1'b1;
    #12 data_i <= 1'b0;

    #25 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
