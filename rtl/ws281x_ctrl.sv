/*
 * ws281x_ctrl.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws281x_ctrl(
    input logic clk_i,
    input logic rst_n_i,

    input logic bit_rdy_i,

    input logic        wr_done_i,
    input logic [31:0] rd_data_i,
    input logic [ 7:0] tim_cnt_i,

    output logic bit_vld_o,
    output logic bit_data_o,

    output logic       rd_en_o,
    output logic [5:0] rd_addr_o
);

typedef enum logic [1:0] {
    IDLE,       // Idle
    READ_RAM,   // Read RAM Data
    SEND_BIT,   // Send Bit Code
    SYNC_BIT    // Sync Bit Code
} state_t;

state_t ctl_sta;

logic       bit_st;
logic [4:0] bit_sel;
logic [8:0] bit_cnt;

logic bit_vld, bit_data;

logic        rd_done;
logic [ 5:0] rd_addr;
logic [23:0] rd_data;

wire ram_next = (bit_sel == 5'd23);
wire ram_done = (rd_addr == 6'h00);

wire bit_next = bit_st | bit_rdy_i;
wire cnt_done = (bit_cnt[8:0] == {tim_cnt_i, 1'b0} - 3'b110);

assign bit_vld_o  = bit_vld;
assign bit_data_o = bit_data;

assign rd_en_o   = (ctl_sta == READ_RAM) & ~rd_done;
assign rd_addr_o = rd_addr;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        ctl_sta <= IDLE;

        bit_st  <= 1'b0;
        bit_sel <= 5'h00;
        bit_cnt <= 9'h000;

        bit_vld  <= 1'b0;
        bit_data <= 1'b0;

        rd_done <= 1'b0;
        rd_addr <= 6'h00;
        rd_data <= 24'h00_0000;
    end else begin
        case (ctl_sta)
            IDLE:
                ctl_sta <= wr_done_i ? READ_RAM : ctl_sta;
            READ_RAM:
                ctl_sta <= rd_done ? SEND_BIT : ctl_sta;
            SEND_BIT:
                ctl_sta <= (bit_next & ram_next) ? (ram_done ? SYNC_BIT : READ_RAM) : ctl_sta;
            SYNC_BIT:
                ctl_sta <= cnt_done ? IDLE : ctl_sta;
            default:
                ctl_sta <= IDLE;
        endcase

        bit_st  <= (ctl_sta != SEND_BIT) & ((ctl_sta == IDLE) | bit_st);
        bit_sel <= (ctl_sta == SEND_BIT) ? bit_sel + bit_next : 5'h00;
        bit_cnt <= (ctl_sta == SYNC_BIT) ? bit_cnt + 1'b1 : 9'h000;

        bit_vld  <= (ctl_sta == SEND_BIT) & bit_next;
        bit_data <= (ctl_sta == SEND_BIT) & bit_next ? rd_data[5'd23 - bit_sel] : bit_data;

        rd_done <= rd_en_o;
        rd_addr <= rd_done ? rd_data_i[29:24] : rd_addr;
        rd_data <= rd_done ? rd_data_i[23:0] : rd_data;
    end
end

endmodule
