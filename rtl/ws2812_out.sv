/*
 * ws2812_out.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_out(
    input logic clk_in,
    input logic rst_n_in,

    input logic bit_rdy_in,
    input logic bit_data_in,

    input logic [7:0] t0h_cnt_in,
    input logic [7:0] t0l_cnt_in,
    input logic [7:0] t1h_cnt_in,
    input logic [7:0] t1l_cnt_in,

    output logic bit_done_out,
    output logic ws2812_data_out
);

logic bit_bsy;
logic [8:0] bit_cnt;
logic [7:0] cnt_sum;

wire t0h_time = (bit_cnt[8:1] < t0h_cnt_in);
wire t1h_time = (bit_cnt[8:1] < t1h_cnt_in);

wire cnt_done = (bit_cnt[8:1] == cnt_sum);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        bit_bsy <= 1'b0;
        bit_cnt <= 9'h000;
        cnt_sum <= 8'h00;

        bit_done_out <= 1'b0;
        ws2812_data_out <= 1'b0;
    end else begin
        bit_bsy <= bit_bsy ? ~cnt_done : bit_rdy_in;
        bit_cnt <= bit_bsy ? bit_cnt + 1'b1 : 9'h000;
        cnt_sum <= bit_rdy_in ? bit_data_in ? (t1h_cnt_in + t1l_cnt_in)
                                            : (t0h_cnt_in + t0l_cnt_in)
                                            : cnt_sum;

        bit_done_out <= bit_bsy & cnt_done;
        ws2812_data_out <= bit_bsy & ((bit_data_in & t1h_time) | (~bit_data_in & t0h_time));
    end
end

endmodule
