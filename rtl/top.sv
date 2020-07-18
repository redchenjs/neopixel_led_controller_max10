/*
 * top.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_cube_controller(
    input logic clk_i,          // clk_i = 12 MHz
    input logic rst_n_i,        // rst_n_i, active low

    input logic dc_i,
    input logic spi_sclk_i,
    input logic spi_mosi_i,
    input logic spi_cs_n_i,

    output logic [7:0] ws281x_code_o,

    output logic [7:0] water_led_o,        // Optional, FPS Counter
    output logic [8:0] segment_led_1_o,    // Optional, FPS Counter
    output logic [8:0] segment_led_2_o     // Optional, FPS Counter
);

logic sys_clk;
logic sys_rst_n;

logic       byte_vld;
logic [7:0] byte_data;

logic [8:0] wr_en;
logic       wr_done;
logic [5:0] wr_addr;
logic [3:0] wr_byte_en;

logic [7:0] t0h_cnt;
logic [7:0] t0s_cnt;
logic [7:0] t1h_cnt;
logic [7:0] t1s_cnt;

sys_ctrl sys_ctrl(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .sys_clk_o(sys_clk),
    .sys_rst_n_o(sys_rst_n)
);

spi_slave spi_slave(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .spi_sclk_i(spi_sclk_i),
    .spi_mosi_i(spi_mosi_i),
    .spi_cs_n_i(spi_cs_n_i),

    .byte_vld_o(byte_vld),
    .byte_data_o(byte_data)
);

layer_ctrl layer_ctrl(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .dc_i(dc_i),

    .byte_vld_i(byte_vld),
    .byte_data_i(byte_data),

    .wr_en_o(wr_en),
    .wr_done_o(wr_done),
    .wr_addr_o(wr_addr),
    .wr_byte_en_o(wr_byte_en)
);

layer_conf layer_conf(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[8]),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),

    .t0h_cnt_o(t0h_cnt),
    .t0s_cnt_o(t0s_cnt),
    .t1h_cnt_o(t1h_cnt),
    .t1s_cnt_o(t1s_cnt)
);

layer_code layer_code7(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[7]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[7])
);

layer_code layer_code6(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[6]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[6])
);

layer_code layer_code5(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[5]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[5])
);

layer_code layer_code4(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[4]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[4])
);

layer_code layer_code3(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[3]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[3])
);

layer_code layer_code2(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[2]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[2])
);

layer_code layer_code1(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[1]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[1])
);

layer_code layer_code0(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .wr_en_i(wr_en[0]),
    .wr_done_i(wr_done),
    .wr_addr_i(wr_addr),
    .wr_data_i(byte_data),
    .wr_byte_en_i(wr_byte_en),

    .t0h_cnt_i(t0h_cnt),
    .t0s_cnt_i(t0s_cnt),
    .t1h_cnt_i(t1h_cnt),
    .t1s_cnt_i(t1s_cnt),

    .ws281x_code_o(ws281x_code_o[0])
);

pulse_counter fps_counter(
    .clk_i(sys_clk),
    .rst_n_i(sys_rst_n),

    .pulse_i(wr_done),

    .water_led_o(water_led_o),
    .segment_led_1_o(segment_led_1_o),
    .segment_led_2_o(segment_led_2_o)
);

endmodule
