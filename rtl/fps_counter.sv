/*
 * fps_counter.sv
 *
 *  Created on: 2020-04-07 18:54
 *      Author: Jack Chen <redchenjs@live.com>
 */

module fps_counter(
    input logic clk_i,
    input logic rst_n_i,

    input logic pulse_i,

    output logic [8:0] segment_led_1_o,
    output logic [8:0] segment_led_2_o
);

localparam [26:0] CNT_1_S = 100 * 1000 * 1000;

logic [7:0] count;
logic [7:0] pulse;

logic [26:0] time_cnt;

segment_led segment_led(
    .rst_n_i(rst_n_i),

    .count_i(count),

    .segment_led_1_o(segment_led_1_o),
    .segment_led_2_o(segment_led_2_o)
);

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        count <= 8'h00;
        pulse <= 8'h00;

        time_cnt <= 27'h000_0000;
    end else begin
        count <= (time_cnt == CNT_1_S - 1) ? pulse : count;
        pulse <= (time_cnt == CNT_1_S - 1) ? 8'h00 : pulse + pulse_i;

        time_cnt <= (time_cnt == CNT_1_S - 1) ? 27'h000_0000 : time_cnt + 1'b1;
    end
end

endmodule
