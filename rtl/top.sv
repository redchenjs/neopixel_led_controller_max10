/*
 * top.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_cube_controller(
    input logic clk_in,      // clk_in = 12 MHz
    input logic rst_n_in,    // rst_n_in, active low

    input logic dc_in,
    input logic spi_sclk_in,
    input logic spi_mosi_in,
    input logic spi_cs_n_in,

    output logic [7:0] ws281x_code_out,

    output logic [7:0] water_led_out,        // Optional, FPS Counter
    output logic [8:0] segment_led_1_out,    // Optional, FPS Counter
    output logic [8:0] segment_led_2_out     // Optional, FPS Counter
);

logic sys_clk;
logic sys_rst_n;

logic       byte_rdy;
logic [7:0] byte_data;

logic [8:0] wr_en;
logic       wr_done;
logic [5:0] wr_addr;
logic [3:0] wr_byte_en;

logic [ 7:0] t0h_cnt;
logic [ 7:0] t0l_cnt;
logic [ 7:0] t1h_cnt;
logic [ 7:0] t1l_cnt;
logic [15:0] rst_cnt;

sys_ctrl sys_ctrl(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .sys_clk_out(sys_clk),
    .sys_rst_n_out(sys_rst_n)
);

spi_slave spi_slave(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .spi_sclk_in(spi_sclk_in),
    .spi_mosi_in(spi_mosi_in),
    .spi_cs_n_in(spi_cs_n_in),

    .byte_rdy_out(byte_rdy),
    .byte_data_out(byte_data)
);

layer_ctrl layer_ctrl(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .dc_in(dc_in),

    .byte_rdy_in(byte_rdy),
    .byte_data_in(byte_data),

    .wr_en_out(wr_en),
    .wr_done_out(wr_done),
    .wr_addr_out(wr_addr),
    .wr_byte_en_out(wr_byte_en)
);

layer_conf layer_conf(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[8]),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),

    .t0h_cnt_out(t0h_cnt),
    .t0l_cnt_out(t0l_cnt),
    .t1h_cnt_out(t1h_cnt),
    .t1l_cnt_out(t1l_cnt),
    .rst_cnt_out(rst_cnt)
);

layer_code layer_code7(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[7]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[7])
);

layer_code layer_code6(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[6]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[6])
);

layer_code layer_code5(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[5]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[5])
);

layer_code layer_code4(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[4]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[4])
);

layer_code layer_code3(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[3]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[3])
);

layer_code layer_code2(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[2]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[2])
);

layer_code layer_code1(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[1]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[1])
);

layer_code layer_code0(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .wr_en_in(wr_en[0]),
    .wr_done_in(wr_done),
    .wr_addr_in(wr_addr),
    .wr_data_in(byte_data),
    .wr_byte_en_in(wr_byte_en),

    .t0h_cnt_in(t0h_cnt),
    .t0l_cnt_in(t0l_cnt),
    .t1h_cnt_in(t1h_cnt),
    .t1l_cnt_in(t1l_cnt),
    .rst_cnt_in(rst_cnt),

    .ws281x_code_out(ws281x_code_out[0])
);

pulse_counter fps_counter(
    .clk_in(sys_clk),
    .rst_n_in(sys_rst_n),

    .pulse_in(wr_done),

    .water_led_out(water_led_out),
    .segment_led_1_out(segment_led_1_out),
    .segment_led_2_out(segment_led_2_out)
);

endmodule
