/*
 * pulse_counter.v
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

parameter [31:0] CNT_1_S = 2 * 100 * 1000 * 1000;

logic [7:0] pul;
logic [7:0] pul_cnt;
logic [31:0] tim_cnt;

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
        tim_cnt <= 32'h00;
    end else begin
        if (tim_cnt == CNT_1_S) begin
            pul <= pul_cnt;

            pul_cnt <= 8'h00;
            tim_cnt <= 32'h00;
        end else begin
            if (pulse_in == 1'b1) begin
                pul_cnt <= pul_cnt + 1'b1;
            end

            tim_cnt <= tim_cnt + 1'b1;
        end
    end
end

endmodule
