/*
 * pulse_counter.sv
 *
 *  Created on: 2020-04-07 18:54
 *      Author: Jack Chen <redchenjs@live.com>
 */

module pulse_counter(
    input logic clk_in,
    input logic rst_n_in,

    input logic pulse_in,

    output logic [7:0] water_led_out,
    output logic [8:0] segment_led_1_out,
    output logic [8:0] segment_led_2_out
);

parameter [27:0] CNT_1_S = 2 * 100 * 1000 * 1000;

logic [7:0] pul;
logic [7:0] pul_cnt;
logic [27:0] tim_cnt;

wire timeout = (tim_cnt == CNT_1_S);

assign water_led_out = rst_n_in ? ~pul_cnt : 8'hff;

segment_led segment_led(
    .rst_n_in(rst_n_in),

    .count(pul),

    .segment_led_1(segment_led_1_out),
    .segment_led_2(segment_led_2_out)
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        pul <= 8'h00;

        pul_cnt <= 8'h00;
        tim_cnt <= 28'h000_0000;
    end else begin
        pul <= timeout ? pul_cnt : pul;

        pul_cnt <= timeout ? 8'h00 : pul_cnt + pulse_in;
        tim_cnt <= timeout ? 28'h000_0000 : tim_cnt + 1'b1;
    end
end

endmodule
