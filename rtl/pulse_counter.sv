/*
 * pulse_counter.sv
 *
 *  Created on: 2020-04-07 18:54
 *      Author: Jack Chen <redchenjs@live.com>
 */

module pulse_counter(
    input logic clk_i,
    input logic rst_n_i,

    input logic pulse_i,

    output logic [7:0] water_led_o,
    output logic [8:0] segment_led_1_o,
    output logic [8:0] segment_led_2_o
);

localparam [27:0] CNT_1_S = 200 * 1000 * 1000;

logic [ 7:0] pulse;
logic [ 7:0] pul_cnt;
logic [27:0] tim_cnt;

assign water_led_o = rst_n_i ? ~pul_cnt : 8'hff;

segment_led segment_led(
    .rst_n_i(rst_n_i),
    .count_i(pulse),
    .segment_led_1_o(segment_led_1_o),
    .segment_led_2_o(segment_led_2_o)
);

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        pulse   <= 8'h00;
        pul_cnt <= 8'h00;
        tim_cnt <= 28'h000_0000;
    end else begin
        pulse   <= (tim_cnt == CNT_1_S) ? pul_cnt : pulse;
        pul_cnt <= (tim_cnt == CNT_1_S) ? 8'h00 : pul_cnt + pulse_i;
        tim_cnt <= (tim_cnt == CNT_1_S) ? 28'h000_0000 : tim_cnt + 1'b1;
    end
end

endmodule
