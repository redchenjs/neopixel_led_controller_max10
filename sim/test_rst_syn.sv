/*
 * test_rst_syn.sv
 *
 *  Created on: 2020-07-08 18:12
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_rst_syn;

logic clk_i;
logic rst_n_i;

logic rst_n_o;

rst_syn test_rst_syn(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .rst_n_o(rst_n_o)
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
    #13 rst_n_i <= 1'b0;
    #13 rst_n_i <= 1'b1;

    #25 $stop;
end

endmodule
