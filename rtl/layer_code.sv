/*
 * layer_code.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_code(
    input logic clk_in,
    input logic rst_n_in,

    input logic       wr_en_in,
    input logic       wr_done_in,
    input logic [5:0] wr_addr_in,
    input logic [7:0] wr_data_in,
    input logic [3:0] wr_byte_en_in,

    input logic [7:0] t0h_cnt_in,
    input logic [7:0] t0s_cnt_in,
    input logic [7:0] t1h_cnt_in,
    input logic [7:0] t1s_cnt_in,

    output logic ws281x_code_out
);

logic        rd_en;
logic [ 5:0] rd_addr;
logic [31:0] rd_data;
logic [ 7:0] tim_sum;

logic bit_rdy, bit_data, bit_done;

ram64 ram64(
    .aclr(~rst_n_in),
    .byteena_a(wr_byte_en_in),
    .clock(clk_in),
    .data({wr_data_in, wr_data_in, wr_data_in, wr_data_in}),
    .rdaddress(rd_addr),
    .rden(rd_en),
    .wraddress(wr_addr_in),
    .wren(wr_en_in),
    .q(rd_data)
);

ws281x_ctrl ws281x_ctrl(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_done_in(bit_done),

    .wr_done_in(wr_done_in),
    .rd_data_in(rd_data),
    .tim_sum_in(tim_sum),

    .bit_rdy_out(bit_rdy),
    .bit_data_out(bit_data),

    .rd_en_out(rd_en),
    .rd_addr_out(rd_addr)
);

ws281x_conf ws281x_conf(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_rdy_in(bit_rdy),
    .bit_data_in(bit_data),

    .t0h_cnt_in(t0h_cnt_in),
    .t0s_cnt_in(t0s_cnt_in),
    .t1h_cnt_in(t1h_cnt_in),
    .t1s_cnt_in(t1s_cnt_in),

    .tim_sum_out(tim_sum)
);

ws281x_code ws281x_code(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_rdy_in(bit_rdy),
    .bit_data_in(bit_data),

    .t0h_cnt_in(t0h_cnt_in),
    .t1h_cnt_in(t1h_cnt_in),
    .tim_sum_in(tim_sum),

    .bit_done_out(bit_done),
    .bit_code_out(ws281x_code_out)
);

endmodule
