/*
 * fps_counter.v
 *
 *  Created on: 2020-04-07 18:54
 *      Author: Jack Chen <redchenjs@live.com>
 */

module fps_counter(
    input wire clk_in,
    input wire rst_n_in,

    input wire pulse_in,

    output wire [7:0] water_led_out,
    output wire [8:0] segment_led_1_out,
    output wire [8:0] segment_led_2_out
);

parameter [31:0] CNT_1_S = 2 * 100 * 1000 * 1000;

reg [7:0] fps;
reg [7:0] fps_cnt;
reg [31:0] tim_cnt;

assign water_led_out = rst_n_in ? ~fps_cnt : 8'hff;

segment_led segment_led(
    .rst_n_in(rst_n_in),

    .count(fps),

    .segment_led_1(segment_led_1_out),
    .segment_led_2(segment_led_2_out)
);

always @(posedge clk_in)
begin
    if (tim_cnt == CNT_1_S) begin
        fps <= fps_cnt;

        fps_cnt <= 8'h00;
        tim_cnt <= 32'h00;
    end else begin
        if (pulse_in == 1'b1) begin
            fps_cnt <= fps_cnt + 1'b1;
        end

        tim_cnt <= tim_cnt + 1'b1;
    end
end

endmodule
