/*
 * layer_code.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_code(
    input logic clk_i,
    input logic rst_n_i,

    input logic       wr_en_i,
    input logic       wr_done_i,
    input logic [5:0] wr_addr_i,
    input logic [7:0] wr_data_i,
    input logic [3:0] wr_byte_en_i,

    input logic [7:0] t0h_cnt_i,
    input logic [7:0] t0s_cnt_i,
    input logic [7:0] t1h_cnt_i,
    input logic [7:0] t1s_cnt_i,

    output logic ws281x_code_o
);

logic        rd_en;
logic [ 5:0] rd_addr;
logic [31:0] rd_data;
logic [ 7:0] tim_cnt;

logic bit_vld, bit_rdy, bit_data;

ram64 ram64(
    .aclr(~rst_n_i),
    .byteena_a(wr_byte_en_i),
    .clock(clk_i),
    .data({wr_data_i, wr_data_i, wr_data_i, wr_data_i}),
    .rdaddress(rd_addr),
    .rden(rd_en),
    .wraddress(wr_addr_i),
    .wren(wr_en_i),
    .q(rd_data)
);

ws281x_ctrl ws281x_ctrl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_rdy_i(bit_rdy),

    .wr_done_i(wr_done_i),
    .rd_data_i(rd_data),
    .tim_cnt_i(tim_cnt),

    .bit_vld_o(bit_vld),
    .bit_data_o(bit_data),

    .rd_en_o(rd_en),
    .rd_addr_o(rd_addr)
);

ws281x_conf ws281x_conf(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_vld_i(bit_vld),
    .bit_data_i(bit_data),

    .t0h_cnt_i(t0h_cnt_i),
    .t0s_cnt_i(t0s_cnt_i),
    .t1h_cnt_i(t1h_cnt_i),
    .t1s_cnt_i(t1s_cnt_i),

    .tim_cnt_o(tim_cnt)
);

ws281x_code ws281x_code(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_vld_i(bit_vld),
    .bit_data_i(bit_data),

    .t0h_cnt_i(t0h_cnt_i),
    .t1h_cnt_i(t1h_cnt_i),
    .tim_cnt_i(tim_cnt),

    .bit_rdy_o(bit_rdy),
    .bit_code_o(ws281x_code_o)
);

endmodule
