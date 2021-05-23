/*
 * channel_out.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module channel_out(
    input logic clk_i,
    input logic rst_n_i,

    input logic [7:0] reg_t0h_time_i,
    input logic [8:0] reg_t0s_time_i,
    input logic [7:0] reg_t1h_time_i,
    input logic [8:0] reg_t1s_time_i,

    input logic       ram_wr_en_i,
    input logic       ram_wr_done_i,
    input logic [7:0] ram_wr_addr_i,
    input logic [7:0] ram_wr_data_i,
    input logic [3:0] ram_wr_byte_en_i,

    output logic bit_code_o
);

logic  [7:0] ram_rd_addr;
logic [31:0] ram_rd_data;

logic bit_vld, bit_rdy, bit_data;

ram256 ram256(
    .clock(clk_i),
    .data({ram_wr_data_i, ram_wr_data_i, ram_wr_data_i, ram_wr_data_i}),
    .rdaddress(ram_rd_addr),
    .wraddress(ram_wr_addr_i),
    .byteena_a(ram_wr_byte_en_i),
    .wren(ram_wr_en_i),
    .q(ram_rd_data)
);

waveform_ctl waveform_ctl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_rdy_i(bit_rdy),

    .ram_wr_done_i(ram_wr_done_i),
    .ram_rd_data_i(ram_rd_data),

    .bit_vld_o(bit_vld),
    .bit_data_o(bit_data),

    .ram_rd_addr_o(ram_rd_addr)
);

waveform_gen waveform_gen(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .bit_vld_i(bit_vld),
    .bit_data_i(bit_data),

    .reg_t0h_time_i(reg_t0h_time_i),
    .reg_t0s_time_i(reg_t0s_time_i),
    .reg_t1h_time_i(reg_t1h_time_i),
    .reg_t1s_time_i(reg_t1s_time_i),

    .bit_rdy_o(bit_rdy),
    .bit_code_o(bit_code_o)
);

endmodule
