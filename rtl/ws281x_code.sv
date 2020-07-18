/*
 * ws281x_code.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_code(
    input logic clk_i,
    input logic rst_n_i,

    input logic bit_vld_i,
    input logic bit_data_i,

    input logic [7:0] t0h_cnt_i,
    input logic [7:0] t1h_cnt_i,
    input logic [7:0] tim_cnt_i,

    output logic bit_rdy_o,
    output logic bit_code_o
);

logic       bit_bsy;
logic [8:0] bit_cnt;

logic bit_rdy, bit_code;

wire cnt_done = (bit_cnt[8:0] == {tim_cnt_i, 1'b0} - 2'b11);

wire t0h_time = (bit_cnt[8:1] < t0h_cnt_i);
wire t1h_time = (bit_cnt[8:1] < t1h_cnt_i);

assign bit_rdy_o  = bit_rdy;
assign bit_code_o = bit_code;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        bit_bsy <= 1'b0;
        bit_cnt <= 9'h000;

        bit_rdy  <= 1'b0;
        bit_code <= 1'b0;
    end else begin
        bit_bsy <= bit_bsy ? ~cnt_done : bit_vld_i;
        bit_cnt <= bit_bsy ? bit_cnt + 1'b1 : 9'h000;

        bit_rdy  <= bit_bsy & cnt_done;
        bit_code <= bit_bsy & ((bit_data_i & t1h_time) | (~bit_data_i & t0h_time));
    end
end

endmodule
