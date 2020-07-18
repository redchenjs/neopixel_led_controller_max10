/*
 * layer_conf.sv
 *
 *  Created on: 2020-04-29 20:16
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_conf(
    input logic clk_i,
    input logic rst_n_i,

    input logic       wr_en_i,
    input logic [5:0] wr_addr_i,
    input logic [7:0] wr_data_i,

    output logic [7:0] t0h_cnt_o,
    output logic [7:0] t0s_cnt_o,
    output logic [7:0] t1h_cnt_o,
    output logic [7:0] t1s_cnt_o
);

logic [7:0] t0h_cnt;
logic [7:0] t0s_cnt;
logic [7:0] t1h_cnt;
logic [7:0] t1s_cnt;

assign t0h_cnt_o = t0h_cnt;
assign t0s_cnt_o = t0s_cnt;
assign t1h_cnt_o = t1h_cnt;
assign t1s_cnt_o = t1s_cnt;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        t0h_cnt <= 8'h00;
        t0s_cnt <= 8'h00;
        t1h_cnt <= 8'h00;
        t1s_cnt <= 8'h00;
    end else begin
        if (wr_en_i) begin
            case (wr_addr_i[1:0])
                2'b00:
                    t0h_cnt <= wr_data_i;
                2'b01:
                    t0s_cnt <= wr_data_i + t0h_cnt;
                2'b10:
                    t1h_cnt <= wr_data_i;
                2'b11:
                    t1s_cnt <= wr_data_i + t1h_cnt;
            endcase
        end
    end
end

endmodule
