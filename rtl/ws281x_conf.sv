/*
 * ws281x_conf.sv
 *
 *  Created on: 2020-07-10 14:29
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_conf(
    input logic clk_i,
    input logic rst_n_i,

    input logic bit_vld_i,
    input logic bit_data_i,

    input logic [7:0] t0h_cnt_i,
    input logic [7:0] t0s_cnt_i,
    input logic [7:0] t1h_cnt_i,
    input logic [7:0] t1s_cnt_i,

    output logic [7:0] tim_cnt_o
);

logic [7:0] tim_cnt;

assign tim_cnt_o = tim_cnt;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        tim_cnt <= 8'h00;
    end else begin
        tim_cnt <= bit_vld_i ? (bit_data_i ? t1s_cnt_i : t0s_cnt_i) : tim_cnt;
    end
end

endmodule
