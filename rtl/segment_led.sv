/*
 * segment_led.sv
 *
 *  Created on: 2020-04-07 18:54
 *      Author: Jack Chen <redchenjs@live.com>
 */

module segment_led(
    input logic rst_n_i,

    input logic [7:0] count_i,

    output logic [8:0] segment_led_1_o,
    output logic [8:0] segment_led_2_o
);

logic [6:0] segment_num[16] = '{
    7'h3f, 7'h06, 7'h5b, 7'h4f, 7'h66, 7'h6d, 7'h7d, 7'h07, // 0 1 2 3 4 5 6 7
    7'h7f, 7'h6f, 7'h77, 7'h40, 7'h39, 7'h5e, 7'h79, 7'h71  // 8 9 A b C d E F
};

wire [3:0] num_1 = (count_i / 10) % 10;
wire [3:0] num_2 = count_i % 10;

assign segment_led_1_o[6:0] = segment_num[num_1];
assign segment_led_1_o[7]   = (count_i / 100 >= 2) ? 1'b1 : 1'b0;
assign segment_led_1_o[8]   = ~rst_n_i;

assign segment_led_2_o[6:0] = segment_num[num_2];
assign segment_led_2_o[7]   = (count_i / 100 >= 1) ? 1'b1 : 1'b0;
assign segment_led_2_o[8]   = ~rst_n_i;

endmodule
