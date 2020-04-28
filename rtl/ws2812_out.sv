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

    output logic bit_done_out,
    output logic ws2812_data_out
);

parameter [8:0] CNT_0_35_US = 2 * 35;
parameter [8:0] CNT_1_36_US = 2 * 136;
parameter [8:0] CNT_1_71_US = 2 * 171;

logic bit_bsy;
logic [8:0] bit_cnt;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        bit_bsy <= 1'b0;
        bit_cnt <= 9'h000;

        bit_done_out <= 1'b0;
        ws2812_data_out <= 1'b0;
    end else begin
        bit_bsy <= bit_bsy ? (bit_cnt != CNT_1_71_US) : bit_rdy_in;
        bit_cnt <= bit_bsy ? bit_cnt + 1'b1 : 9'h000;

        bit_done_out <= bit_bsy & (bit_cnt == CNT_1_71_US);
        ws2812_data_out <= bit_bsy & ((bit_data_in & (bit_cnt < CNT_1_36_US))
                                   | (~bit_data_in & (bit_cnt < CNT_0_35_US)));
    end
end

endmodule
