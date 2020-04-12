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
    input logic layer_en_in,
    input logic frame_rdy_in,
    input logic [5:0] wr_addr_in,
    input logic [3:0] byte_en_in,
    input logic [7:0] byte_data_in,

    output logic bit_rdy_out,
    output logic bit_data_out
);

parameter [15:0] CNT_50_US = 2 * 5000;

parameter [1:0] IDLE = 2'b00;       // Idle
parameter [1:0] READ_RAM = 2'b01;   // Read RAM Data
parameter [1:0] SEND_BIT = 2'b10;   // Send Data Bit
parameter [1:0] SEND_RST = 2'b11;   // Send Reset Code

logic bit_rdy;

logic ram_rd_st;
logic ram_rd_en;
logic [31:0] ram_rd_q;

logic [5:0] ram_rd_addr;
logic [23:0] ram_rd_data;

logic [1:0] ctl_sta;

logic [4:0] bit_sel;
logic [15:0] rst_cnt;

logic ram_rd_rdy;
logic ram_rd_done;

wire bit_done = ram_rd_st | bit_done_in;
wire ram_next = bit_done & (bit_sel == 5'd23);
wire ram_done = (ram_rd_addr == 6'h00);

edge2en bit_rdy_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),
    .edge_in(bit_rdy),
    .rising_out(bit_rdy_out)
);

edge2en ram_rd_en_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),
    .edge_in(ram_rd_en),
    .rising_out(ram_rd_rdy)
);

edge2en ram_rd_rdy_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),
    .edge_in(ram_rd_rdy),
    .rising_out(ram_rd_done)
);

ram64 ram64(
    .aclr(~rst_n_in),
    .byteena_a(byte_en_in),
    .clock(clk_in),
    .data({byte_data_in, byte_data_in, byte_data_in, byte_data_in}),
    .rdaddress(ram_rd_addr),
    .rden(ram_rd_rdy),
    .wraddress(wr_addr_in),
    .wren(layer_en_in),
    .q(ram_rd_q)
);

always_ff @(posedge clk_in)
begin
    ram_rd_addr <= ram_rd_q[29:24];
    ram_rd_data <= ram_rd_q[23:0];
end

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        ctl_sta <= IDLE;

        bit_rdy <= 1'b0;

        ram_rd_st <= 1'b0;
        ram_rd_en <= 1'b0;

        bit_sel <= 5'h00;
        rst_cnt <= 16'h0000;

        bit_data_out <= 1'b0;
    end else begin
        case (ctl_sta)
        IDLE:
            ctl_sta <= frame_rdy_in ? READ_RAM : ctl_sta;
        READ_RAM:
            ctl_sta <= ram_rd_done ? SEND_BIT : ctl_sta;
        SEND_BIT:
            ctl_sta <= ram_next ? (ram_done ? SEND_RST : READ_RAM) : ctl_sta;
        SEND_RST:
            ctl_sta <= (rst_cnt == CNT_50_US) ? IDLE : ctl_sta;
        default:
            ctl_sta <= IDLE;
        endcase

        bit_rdy <= (ctl_sta == SEND_BIT) & bit_done;

        ram_rd_st <= ((ctl_sta == IDLE) | ram_rd_st) & (ctl_sta != SEND_BIT);
        ram_rd_en <= (ctl_sta == READ_RAM) & ~ram_rd_done;

        bit_sel <= (ctl_sta == SEND_BIT) ? bit_sel + bit_done : 5'h00;
        rst_cnt <= (ctl_sta == SEND_RST) ? rst_cnt + 1'b1 : 16'h0000;

        bit_data_out <= ram_rd_data[5'd23 - bit_sel];
    end
end

endmodule
