/*
 * waveform_gen.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module waveform_gen(
    input logic clk_i,
    input logic rst_n_i,

    input logic bit_vld_i,
    input logic bit_data_i,

    input logic [7:0] reg_t0h_time_i,
    input logic [8:0] reg_t0s_time_i,
    input logic [7:0] reg_t1h_time_i,
    input logic [8:0] reg_t1s_time_i,

    output logic bit_rdy_o,
    output logic bit_code_o
);

logic [8:0] bit_cnt;

logic bit_busy, bit_code;

wire [8:0] bit_time = bit_data_i ? reg_t1s_time_i : reg_t0s_time_i;

wire t0h_code = (bit_cnt <= reg_t0h_time_i) & ~bit_data_i;
wire t1h_code = (bit_cnt <= reg_t1h_time_i) &  bit_data_i;

wire bit_done = (bit_cnt == bit_time);

assign bit_rdy_o  = bit_busy & bit_done;
assign bit_code_o = bit_code;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        bit_cnt <= 9'h000;

        bit_busy <= 1'b0;
        bit_code <= 1'b0;
    end else begin
        bit_cnt <= bit_busy ? bit_cnt + 1'b1 : 9'h000;

        bit_busy <= bit_busy ? ~bit_done : bit_vld_i;
        bit_code <= bit_busy & (t0h_code | t1h_code);
    end
end

endmodule
