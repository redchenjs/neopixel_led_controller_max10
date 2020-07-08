/*
 * test_rst_sync.sv
 *
 *  Created on: 2020-07-08 18:12
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_rst_sync;

logic clk_in;
logic rst_n_in;

logic rst_n_out;

rst_sync test_rst_sync(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .rst_n_out(rst_n_out)
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
    #13 rst_n_in <= 1'b0;
    #13 rst_n_in <= 1'b1;

    #25 $stop;
end

endmodule
