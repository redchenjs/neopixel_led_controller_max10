/*
 * ws2812_code.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_code(
    input logic clk_in,
    input logic rst_n_in,

    input logic bit_rdy_in,
    input logic bit_data_in,

    input logic [7:0] t0h_cnt_in,
    input logic [7:0] t0l_cnt_in,
    input logic [7:0] t1h_cnt_in,
    input logic [7:0] t1l_cnt_in,

    output logic bit_done_out,
    output logic bit_code_out
);

logic [7:0] cnt_sum;

logic       bit_bsy;
logic [8:0] bit_cnt;

logic bit_done, bit_code;

wire [7:0] t0_sum = t0h_cnt_in + t0l_cnt_in;
wire [7:0] t1_sum = t1h_cnt_in + t1l_cnt_in;

wire cnt_done = (bit_cnt[8:1] == cnt_sum);

wire t0h_time = (bit_cnt[8:1] < t0h_cnt_in);
wire t1h_time = (bit_cnt[8:1] < t1h_cnt_in);

assign bit_done_out = bit_done;
assign bit_code_out = bit_code;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        cnt_sum <= 8'h00;

        bit_bsy <= 1'b0;
        bit_cnt <= 9'h000;

        bit_done <= 1'b0;
        bit_code <= 1'b0;
    end else begin
        cnt_sum <= bit_rdy_in ? (bit_data_in ? t1_sum : t0_sum) : cnt_sum;

        bit_bsy <= bit_bsy ? ~cnt_done : bit_rdy_in;
        bit_cnt <= bit_bsy ? bit_cnt + 1'b1 : 9'h000;

        bit_done <= bit_bsy & cnt_done;
        bit_code <= bit_bsy & ((bit_data_in & t1h_time) | (~bit_data_in & t0h_time));
    end
end

endmodule
