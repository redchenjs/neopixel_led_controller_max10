/*
 * ws2812_ctl.sv
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_ctl(
    input logic clk_in,
    input logic rst_n_in,

    input logic bit_done_in,

    input logic wr_en_in,
    input logic wr_done_in,
    input logic [5:0] wr_addr_in,
    input logic [7:0] wr_data_in,
    input logic [3:0] wr_byte_en_in,

    input logic [15:0] rst_cnt_in,

    output logic bit_rdy_out,
    output logic bit_data_out
);

parameter [1:0] IDLE = 2'b00;       // Idle
parameter [1:0] READ_RAM = 2'b01;   // Read RAM Data
parameter [1:0] SEND_BIT = 2'b10;   // Send Data Bit
parameter [1:0] SEND_RST = 2'b11;   // Send Reset Code

logic [1:0] ctl_sta;

logic ram_rd_st;
logic ram_rd_done;
logic [31:0] ram_rd_q;

logic [5:0] ram_rd_addr;
logic [23:0] ram_rd_data;

logic [4:0] bit_sel;
logic [16:0] rst_cnt;

wire ram_rd_en = (ctl_sta == READ_RAM);

wire bit_next = ram_rd_st | bit_done_in;
wire bit_done = (ctl_sta == SEND_BIT) & bit_next;

wire ram_next = (bit_sel == 5'd23);
wire ram_done = (ram_rd_addr == 6'h00);

wire rst_done = (rst_cnt[16:1] == rst_cnt_in);

ram64 ram64(
    .aclr(~rst_n_in),
    .byteena_a(wr_byte_en_in),
    .clock(clk_in),
    .data({wr_data_in, wr_data_in, wr_data_in, wr_data_in}),
    .rdaddress(ram_rd_addr),
    .rden(ram_rd_en),
    .wraddress(wr_addr_in),
    .wren(wr_en_in),
    .q(ram_rd_q)
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        ctl_sta <= IDLE;

        ram_rd_st <= 1'b0;
        ram_rd_done <= 1'b0;

        ram_rd_addr <= 6'h00;
        ram_rd_data <= 24'h00_0000;

        bit_sel <= 5'h00;
        rst_cnt <= 17'h0_0000;

        bit_rdy_out <= 1'b0;
        bit_data_out <= 1'b0;
    end else begin
        case (ctl_sta)
            IDLE:
                ctl_sta <= wr_done_in ? READ_RAM : ctl_sta;
            READ_RAM:
                ctl_sta <= ram_rd_done ? SEND_BIT : ctl_sta;
            SEND_BIT:
                ctl_sta <= (bit_next & ram_next) ? (ram_done ? SEND_RST : READ_RAM) : ctl_sta;
            SEND_RST:
                ctl_sta <= rst_done ? IDLE : ctl_sta;
            default:
                ctl_sta <= IDLE;
        endcase

        ram_rd_st <= (ctl_sta != SEND_BIT) & ((ctl_sta == IDLE) | ram_rd_st);
        ram_rd_done <= ram_rd_en;

        ram_rd_addr <= ram_rd_done ? ram_rd_q[29:24] : ram_rd_addr;
        ram_rd_data <= ram_rd_done ? ram_rd_q[23:0] : ram_rd_data;

        bit_sel <= (ctl_sta == SEND_BIT) ? bit_sel + bit_next : 5'h00;
        rst_cnt <= (ctl_sta == SEND_RST) ? rst_cnt + 1'b1 : 17'h0_0000;

        bit_rdy_out <= bit_done;
        bit_data_out <= bit_done ? ram_rd_data[5'd23 - bit_sel] : bit_data_out;
    end
end

endmodule
