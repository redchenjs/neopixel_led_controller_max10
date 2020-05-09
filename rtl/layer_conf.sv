/*
 * layer_conf.sv
 *
 *  Created on: 2020-04-29 20:16
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_conf(
    input logic clk_in,
    input logic rst_n_in,

    input logic       wr_en_in,
    input logic [5:0] wr_addr_in,
    input logic [7:0] wr_data_in,

    output logic [ 7:0] t0h_cnt_out,
    output logic [ 7:0] t0l_cnt_out,
    output logic [ 7:0] t1h_cnt_out,
    output logic [ 7:0] t1l_cnt_out,
    output logic [15:0] rst_cnt_out
);

logic [ 7:0] t0h_cnt;
logic [ 7:0] t0l_cnt;
logic [ 7:0] t1h_cnt;
logic [ 7:0] t1l_cnt;
logic [15:0] rst_cnt;

assign t0h_cnt_out = t0h_cnt;
assign t0l_cnt_out = t0l_cnt;
assign t1h_cnt_out = t1h_cnt;
assign t1l_cnt_out = t1l_cnt;
assign rst_cnt_out = rst_cnt;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        t0h_cnt <= 8'h00;
        t0l_cnt <= 8'h00;
        t1h_cnt <= 8'h00;
        t1l_cnt <= 8'h00;
        rst_cnt <= 16'h0000;
    end else begin
        if (wr_en_in) begin
            case (wr_addr_in[2:0])
                3'h0:
                    t0h_cnt <= wr_data_in;
                3'h1:
                    t0l_cnt <= wr_data_in;
                3'h2:
                    t1h_cnt <= wr_data_in;
                3'h3:
                    t1l_cnt <= wr_data_in;
                3'h4:
                    rst_cnt[15:8] <= wr_data_in;
                3'h5:
                    rst_cnt[ 7:0] <= wr_data_in;
            endcase
        end
    end
end

endmodule
