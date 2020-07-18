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

logic [6:0] mem[16];

initial begin
    mem[0]  = 7'h3f;    // 0
    mem[1]  = 7'h06;    // 1
    mem[2]  = 7'h5b;    // 2
    mem[3]  = 7'h4f;    // 3
    mem[4]  = 7'h66;    // 4
    mem[5]  = 7'h6d;    // 5
    mem[6]  = 7'h7d;    // 6
    mem[7]  = 7'h07;    // 7
    mem[8]  = 7'h7f;    // 8
    mem[9]  = 7'h6f;    // 9
    mem[10] = 7'h77;    // A
    mem[11] = 7'h40;    // b
    mem[12] = 7'h39;    // C
    mem[13] = 7'h5e;    // d
    mem[14] = 7'h79;    // E
    mem[15] = 7'h71;    // F
end

wire [3:0] num_1 = (count_i / 10) % 10;
wire [3:0] num_2 = count_i % 10;

assign segment_led_1_o[6:0] = mem[num_1];
assign segment_led_1_o[7]   = (count_i / 100 >= 2) ? 1'b1 : 1'b0;
assign segment_led_1_o[8]   = ~rst_n_i;

assign segment_led_2_o[6:0] = mem[num_2];
assign segment_led_2_o[7]   = (count_i / 100 >= 1) ? 1'b1 : 1'b0;
assign segment_led_2_o[8]   = ~rst_n_i;

endmodule
