/*
 * layer_out.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_out(
    input logic clk_in,
    input logic rst_n_in,

    input logic wr_en_in,
    input logic wr_done_in,
    input logic [5:0] wr_addr_in,
    input logic [7:0] wr_data_in,
    input logic [3:0] wr_byte_en_in,

    input logic [7:0] t0h_cnt_in,
    input logic [7:0] t0l_cnt_in,
    input logic [7:0] t1h_cnt_in,
    input logic [7:0] t1l_cnt_in,
    input logic [15:0] rst_cnt_in,

    output logic ws2812_data_out
);

logic bit_rdy, bit_data, bit_done;

ws2812_ctl ws2812_ctl(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_done_in(bit_done),

    .wr_en_in(wr_en_in),
    .wr_done_in(wr_done_in),
    .wr_addr_in(wr_addr_in),
    .wr_data_in(wr_data_in),
    .wr_byte_en_in(wr_byte_en_in),

    .rst_cnt_in(rst_cnt_in),

    .bit_rdy_out(bit_rdy),
    .bit_data_out(bit_data)
);

ws2812_out ws2812_out(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_rdy_in(bit_rdy),
    .bit_data_in(bit_data),

    .t0h_cnt_in(t0h_cnt_in),
    .t0l_cnt_in(t0l_cnt_in),
    .t1h_cnt_in(t1h_cnt_in),
    .t1l_cnt_in(t1l_cnt_in),

    .bit_done_out(bit_done),
    .ws2812_data_out(ws2812_data_out)
);

endmodule
