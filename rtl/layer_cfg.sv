/*
 * layer_cfg.sv
 *
 *  Created on: 2020-04-29 20:16
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_cfg(
    input logic clk_in,
    input logic rst_n_in,

    input logic wr_en_in,
    input logic [5:0] wr_addr_in,
    input logic [7:0] wr_data_in,

    output logic [7:0] rst_cnt_out,
    output logic [7:0] t1_h_cnt_out,
    output logic [7:0] t1_l_cnt_out,
    output logic [7:0] t0_h_cnt_out,
    output logic [7:0] t0_l_cnt_out
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        rst_cnt_out <= 8'h00;
        t1_h_cnt_out <= 8'h00;
        t1_l_cnt_out <= 8'h00;
        t0_h_cnt_out <= 8'h00;
        t0_l_cnt_out <= 8'h00;
    end else begin
        case ({wr_en_in, wr_addr_in[2:0]})
            4'h8 + 4'h0:
                rst_cnt_out <= wr_data_in;
            4'h8 + 4'h1:
                t1_h_cnt_out <= wr_data_in;
            4'h8 + 4'h2:
                t1_l_cnt_out <= wr_data_in;
            4'h8 + 4'h3:
                t0_h_cnt_out <= wr_data_in;
            4'h8 + 4'h4:
                t0_l_cnt_out <= wr_data_in;
        endcase
    end
end

endmodule
