/*
 * test_waveform_ctl.sv
 *
 *  Created on: 2020-07-08 20:23
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_waveform_ctl;

logic clk_i;
logic rst_n_i;

logic bit_rdy_i;

logic        ram_wr_done_i;
logic [31:0] ram_rd_data_i;

logic bit_vld_o;
logic bit_data_o;

logic [7:0] ram_rd_addr_o;

waveform_ctl test_waveform_ctl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_rdy_i(bit_rdy_i),

    .ram_wr_done_i(ram_wr_done_i),
    .ram_rd_data_i(ram_rd_data_i),

    .bit_vld_o(bit_vld_o),
    .bit_data_o(bit_data_o),

    .ram_rd_addr_o(ram_rd_addr_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    bit_rdy_i <= 1'b0;

    ram_wr_done_i <= 1'b0;
    ram_rd_data_i <= 32'haaaa_cccc;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    #11 ram_wr_done_i <= 1'b1;
    #5  ram_wr_done_i <= 1'b0;

    for (integer i = 0; i < 119; i++) begin
        #50 bit_rdy_i <= 1'b1;
        #5  bit_rdy_i <= 1'b0;
    end

    #500 ram_rd_data_i <= 32'h00aa_dddd;

    for (integer i = 0; i < 119; i++) begin
        #50 bit_rdy_i <= 1'b1;
        #5  bit_rdy_i <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
