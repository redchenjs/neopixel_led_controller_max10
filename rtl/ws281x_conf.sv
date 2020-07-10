/*
 * ws281x_conf.sv
 *
 *  Created on: 2020-07-10 14:29
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_conf(
    input logic clk_in,
    input logic rst_n_in,

    input logic bit_rdy_in,
    input logic bit_data_in,

    input logic [7:0] t0h_cnt_in,
    input logic [7:0] t0l_cnt_in,
    input logic [7:0] t1h_cnt_in,
    input logic [7:0] t1l_cnt_in,

    output logic [7:0] tim_sum_out
);

logic [7:0] tim_sum;

wire [7:0] t0_sum = t0h_cnt_in + t0l_cnt_in;
wire [7:0] t1_sum = t1h_cnt_in + t1l_cnt_in;

assign tim_sum_out = tim_sum;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        tim_sum <= 8'h00;
    end else begin
        tim_sum <= bit_rdy_in ? (bit_data_in ? t1_sum : t0_sum) : tim_sum;
    end
end

endmodule
