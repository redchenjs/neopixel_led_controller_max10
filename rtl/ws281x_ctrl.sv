/*
 * ws281x_ctrl.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_ctrl(
    input logic clk_in,
    input logic rst_n_in,

    input logic bit_done_in,

    input logic        wr_done_in,
    input logic [31:0] rd_data_in,
    input logic [15:0] rst_cnt_in,

    output logic bit_rdy_out,
    output logic bit_data_out,

    output logic       rd_en_out,
    output logic [5:0] rd_addr_out
);

parameter [1:0] IDLE     = 2'b00;   // Idle
parameter [1:0] READ_RAM = 2'b01;   // Read RAM Data
parameter [1:0] SEND_BIT = 2'b10;   // Send Bit Code
parameter [1:0] SEND_RST = 2'b11;   // Send RST Code

logic [1:0] ctl_sta;

logic       bit_st;
logic [4:0] bit_sel;

logic bit_rdy, bit_data;

logic        rd_done;
logic [ 5:0] rd_addr;
logic [23:0] rd_data;

logic [16:0] rst_cnt;

wire ram_next = (bit_sel == 5'd23);
wire ram_done = (rd_addr == 6'h00);

wire bit_next = bit_st | bit_done_in;
wire rst_done = (rst_cnt[16:1] == rst_cnt_in);

assign bit_rdy_out  = bit_rdy;
assign bit_data_out = bit_data;

assign rd_en_out   = (ctl_sta == READ_RAM) & ~rd_done;
assign rd_addr_out = rd_addr;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        ctl_sta <= IDLE;

        bit_st  <= 1'b0;
        bit_sel <= 5'h00;

        bit_rdy  <= 1'b0;
        bit_data <= 1'b0;

        rd_done <= 1'b0;
        rd_addr <= 6'h00;
        rd_data <= 24'h00_0000;

        rst_cnt <= 17'h0_0000;
    end else begin
        case (ctl_sta)
            IDLE:
                ctl_sta <= wr_done_in ? READ_RAM : ctl_sta;
            READ_RAM:
                ctl_sta <= rd_done ? SEND_BIT : ctl_sta;
            SEND_BIT:
                ctl_sta <= (bit_next & ram_next) ? (ram_done ? SEND_RST : READ_RAM) : ctl_sta;
            SEND_RST:
                ctl_sta <= rst_done ? IDLE : ctl_sta;
            default:
                ctl_sta <= IDLE;
        endcase

        bit_st  <= (ctl_sta != SEND_BIT) & ((ctl_sta == IDLE) | bit_st);
        bit_sel <= (ctl_sta == SEND_BIT) ? bit_sel + bit_next : 5'h00;

        bit_rdy  <= (ctl_sta == SEND_BIT) & bit_next;
        bit_data <= (ctl_sta == SEND_BIT) & bit_next ? rd_data[5'd23 - bit_sel] : bit_data;

        rd_done <= rd_en_out;
        rd_addr <= rd_done ? rd_data_in[29:24] : rd_addr;
        rd_data <= rd_done ? rd_data_in[23:0] : rd_data;

        rst_cnt <= (ctl_sta == SEND_RST) ? rst_cnt + 1'b1 : 17'h0_0000;
    end
end

endmodule
