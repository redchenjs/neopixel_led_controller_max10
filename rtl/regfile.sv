/*
 * regfile.sv
 *
 *  Created on: 2020-04-29 20:16
 *      Author: Jack Chen <redchenjs@live.com>
 */

`include "config.sv"

module regfile(
    input logic clk_i,
    input logic rst_n_i,

    input logic [2:0] reg_rd_addr_i,

    input logic       reg_wr_en_i,
    input logic [2:0] reg_wr_addr_i,
    input logic [7:0] reg_wr_data_i,

    output logic [7:0] reg_rd_data_o,

    output logic [7:0] reg_t0h_time_o,
    output logic [8:0] reg_t0s_time_o,
    output logic [7:0] reg_t1h_time_o,
    output logic [8:0] reg_t1s_time_o,

    output logic [7:0] reg_chan_len_o,
    output logic [3:0] reg_chan_cnt_o
);

logic [7:0] regs[5:0];
logic [7:0] data[7:0];

genvar i;
generate
    assign data[0] = 8'h00;
    assign data[1] = {RTL_REVISION_MAJOR, RTL_REVISION_MINOR};

    for (i = 0; i < 6; i++) begin: rd_data
        assign data[i + 2] = regs[i];
    end

    assign reg_t0h_time_o = regs[0];
    assign reg_t0s_time_o = regs[0] + regs[1];
    assign reg_t1h_time_o = regs[2];
    assign reg_t1s_time_o = regs[2] + regs[3];

    assign reg_chan_len_o = regs[4];
    assign reg_chan_cnt_o = regs[5];
endgenerate

assign reg_rd_data_o = data[reg_rd_addr_i];

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        for (integer i = 0; i < 6; i++) begin
            regs[i] <= 8'h00;
        end
    end else begin
        if (reg_wr_en_i) begin
            regs[reg_wr_addr_i] <= reg_wr_data_i;
        end
    end
end

endmodule
