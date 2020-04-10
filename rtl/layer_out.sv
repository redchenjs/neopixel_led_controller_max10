/*
 * layer_out.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_out(
    input logic clk_in,
    input logic rst_n_in,

    input logic layer_en_in,
    input logic frame_rdy_in,
    input logic [5:0] wr_addr_in,
    input logic [3:0] byte_en_in,
    input logic [7:0] byte_data_in,

    output logic ws2812_data_out
);

logic bit_rdy, bit_data, bit_done;

ws2812_ctl ws2812_ctl(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_done_in(bit_done),

    .layer_en_in(layer_en_in),
    .frame_rdy_in(frame_rdy_in),
    .wr_addr_in(wr_addr_in),
    .byte_en_in(byte_en_in),
    .byte_data_in(byte_data_in),

    .bit_rdy_out(bit_rdy),
    .bit_data_out(bit_data)
);

ws2812_out ws2812_out(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .bit_rdy_in(bit_rdy),
    .bit_data_in(bit_data),

    .bit_done_out(bit_done),
    .ws2812_data_out(ws2812_data_out)
);

endmodule
