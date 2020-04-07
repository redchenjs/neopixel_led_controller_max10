/*
 * ws2812_out.v
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_out(
    input wire clk_in,
    input wire rst_n_in,

    input wire bit_rdy_in,
    input wire bit_data_in,

    output wire bit_done_out,
    output wire ws2812_data_out
);

parameter [15:0] CNT_0_35_US = 2 * 35;
parameter [15:0] CNT_1_35_US = 2 * 135;
parameter [15:0] CNT_1_70_US = CNT_0_35_US + CNT_1_35_US;

reg bit_busy;

reg [15:0] bit_cnt;
reg [15:0] code_cnt;

reg [1:0] bit_done_pul;
assign bit_done_out = ~bit_done_pul[0] & bit_done_pul[1];   // Falling Edge Pulse

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        ws2812_data_out <= 1'b0;

        bit_busy <= 1'b0;
        bit_cnt <= 16'h0000;
    end else begin
        if (bit_rdy_in) begin
            bit_busy <= 1'b1;
        end else begin
            if (bit_busy) begin
                if (bit_cnt == CNT_1_70_US) begin
                    bit_busy <= 1'b0;
                    bit_cnt <= 16'h0000;
                end else if (bit_cnt >= code_cnt) begin
                    ws2812_data_out <= 1'b0;

                    bit_cnt <= bit_cnt + 1'b1;
                end else if (bit_cnt == 16'h0000) begin
                    if (bit_data_in) begin
                        code_cnt <= CNT_1_35_US;
                    end else begin
                        code_cnt <= CNT_0_35_US;
                    end

                    ws2812_data_out <= 1'b1;

                    bit_cnt <= bit_cnt + 1'b1;
                end else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end else begin
                ws2812_data_out <= 1'b0;

                bit_busy <= 1'b0;
                bit_cnt <= 16'h0000;
            end
        end
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        bit_done_pul <= 2'b00;
    end else begin
        bit_done_pul[0] <= bit_busy;
        bit_done_pul[1] <= bit_done_pul[0];
    end
end

endmodule
