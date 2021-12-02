/*
 * top.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module neopixel_led_controller(
    input logic clk_i,          // clk_i = 12 MHz
    input logic rst_n_i,        // rst_n_i, active low

    input logic dc_i,

    input logic spi_sclk_i,
    input logic spi_mosi_i,
    input logic spi_cs_n_i,

    output logic spi_miso_o,

    output logic [8:0] segment_led_1_o,    // FPS Counter
    output logic [8:0] segment_led_2_o,    // FPS Counter

    output logic [15:0] neopixel_code_o
);

logic sys_clk;
logic sys_rst_n;

logic       spi_byte_vld;
logic [7:0] spi_byte_data;

logic [7:0] reg_t0h_time;
logic [8:0] reg_t0s_time;
logic [7:0] reg_t1h_time;
logic [8:0] reg_t1s_time;

logic [7:0] reg_chan_len;
logic [3:0] reg_chan_cnt;

logic [2:0] reg_rd_addr;
logic [7:0] reg_rd_data;

logic       reg_wr_en;
logic [2:0] reg_wr_addr;

logic [15:0] ram_wr_en;
logic        ram_wr_done;
logic  [7:0] ram_wr_addr;
logic  [3:0] ram_wr_byte_en;

sys_ctl sys_ctl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .sys_clk_o(sys_clk),
    .sys_rst_n_o(sys_rst_n)
);

spi_slave spi_slave(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .spi_byte_data_i(reg_rd_data),

    .spi_sclk_i(spi_sclk_i),
    .spi_mosi_i(spi_mosi_i),
    .spi_cs_n_i(spi_cs_n_i),

    .spi_miso_o(spi_miso_o),

    .spi_byte_vld_o(spi_byte_vld),
    .spi_byte_data_o(spi_byte_data)
);

channel_ctl channel_ctl(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .dc_i(dc_i),

    .spi_byte_vld_i(spi_byte_vld),
    .spi_byte_data_i(spi_byte_data),

    .reg_chan_len_i(reg_chan_len),
    .reg_chan_cnt_i(reg_chan_cnt),

    .reg_rd_addr_o(reg_rd_addr),

    .reg_wr_en_o(reg_wr_en),
    .reg_wr_addr_o(reg_wr_addr),

    .ram_wr_en_o(ram_wr_en),
    .ram_wr_done_o(ram_wr_done),
    .ram_wr_addr_o(ram_wr_addr),
    .ram_wr_byte_en_o(ram_wr_byte_en)
);

generate
    genvar i;
    for (i = 0; i < 16; i++) begin: channel
        channel_out out(
            .clk_i(sys_clk),
            .rst_n_i(sys_rst_n),

            .reg_t0h_time_i(reg_t0h_time),
            .reg_t0s_time_i(reg_t0s_time),
            .reg_t1h_time_i(reg_t1h_time),
            .reg_t1s_time_i(reg_t1s_time),

            .ram_wr_en_i(ram_wr_en[i]),
            .ram_wr_done_i(ram_wr_done),
            .ram_wr_addr_i(ram_wr_addr),
            .ram_wr_data_i(spi_byte_data),
            .ram_wr_byte_en_i(ram_wr_byte_en),

            .bit_code_o(neopixel_code_o[i])
        );
    end
endgenerate

regfile regfile(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .reg_rd_addr_i(reg_rd_addr),

    .reg_wr_en_i(reg_wr_en),
    .reg_wr_addr_i(reg_wr_addr),
    .reg_wr_data_i(spi_byte_data),

    .reg_t0h_time_o(reg_t0h_time),
    .reg_t0s_time_o(reg_t0s_time),
    .reg_t1h_time_o(reg_t1h_time),
    .reg_t1s_time_o(reg_t1s_time),

    .reg_chan_len_o(reg_chan_len),
    .reg_chan_cnt_o(reg_chan_cnt),

    .reg_rd_data_o(reg_rd_data)
);

fps_counter fps_counter(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .pulse_i(ram_wr_done),

    .segment_led_1_o(segment_led_1_o),
    .segment_led_2_o(segment_led_2_o)
);

endmodule
