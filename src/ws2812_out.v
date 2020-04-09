/*
 * ws2812_out.v
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

parameter [15:0] CNT_0_35_US = 2 * 35;
parameter [15:0] CNT_0_70_US = 2 * 70;
parameter [15:0] CNT_1_25_US = 2 * 125;

logic bit_bsy;

logic [15:0] bit_cnt;
logic [15:0] code_cnt;

edge2en bit_bsy_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .edge_in(bit_bsy),

    .falling_out(bit_done_out)
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        bit_bsy <= 1'b0;

        ws2812_data_out <= 1'b0;
    end else begin
        if (bit_rdy_in) begin
            bit_bsy <= 1'b1;
        end else begin
            if (bit_bsy) begin
                if (bit_cnt == CNT_1_25_US) begin
                    bit_bsy <= 1'b0;
                end else begin
                    if (bit_cnt == 16'h0000) begin
                        if (bit_data_in) begin
                            code_cnt <= CNT_0_70_US;
                        end else begin
                            code_cnt <= CNT_0_35_US;
                        end

                        ws2812_data_out <= 1'b1;
                    end else if (bit_cnt > code_cnt) begin
                        ws2812_data_out <= 1'b0;
                    end

                    bit_cnt <= bit_cnt + 1'b1;
                end
            end else begin
                bit_cnt <= 16'h0000;
            end
        end
    end
end

endmodule
