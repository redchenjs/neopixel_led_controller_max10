/*
 * ws2812_ctl.v
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

parameter [1:0] CTL_INIT = 2'b00;       // Init
parameter [1:0] CTL_READ_RAM = 2'b01;   // Read RAM Data
parameter [1:0] CTL_SEND_BIT = 2'b10;   // Send Data Bit
parameter [1:0] CTL_SEND_RST = 2'b11;   // Send Reset Code

logic bit_rdy;
logic [4:0] bit_sel;

logic ram_rd_en;
logic ram_rd_init;
logic [5:0] ram_rd_addr;
logic [31:0] ram_rd_data;

logic [1:0] ctl_sta;
logic [15:0] code_cnt;

logic ram_rd_rdy;
logic ram_rd_done;

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
    .byteena_a(byte_en_in),
    .clock(clk_in),
    .data({byte_data_in, byte_data_in, byte_data_in, byte_data_in}),
    .rdaddress(ram_rd_addr),
    .rden(ram_rd_rdy),
    .wraddress(wr_addr_in),
    .wren(layer_en_in),
    .q(ram_rd_data)
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        ctl_sta <= CTL_INIT;
    end else begin
        case (ctl_sta)
        CTL_INIT:
            if (frame_rdy_in) begin
                ctl_sta <= CTL_READ_RAM;

                bit_rdy <= 1'b0;
                bit_sel <= 5'h00;

                ram_rd_en <= 1'b0;
                ram_rd_init <= 1'b1;
                ram_rd_addr <= 6'h00;

                code_cnt <= 16'h0000;
            end
        CTL_READ_RAM: begin
            if (ram_rd_done) begin
                ctl_sta <= CTL_SEND_BIT;

                ram_rd_addr <= ram_rd_data[29:24];

                ram_rd_en <= 1'b0;
            end else begin
                ram_rd_en <= 1'b1;
            end
        end
        CTL_SEND_BIT:
            if (ram_rd_init || bit_done_in) begin
                ram_rd_init <= 1'b0;

                bit_rdy <= 1'b1;
                bit_data_out <= ram_rd_data[5'd23 - bit_sel];

                if (bit_sel == 5'd23) begin
                    bit_sel <= 5'h00;

                    if (ram_rd_addr == 6'h00) begin
                        ctl_sta <= CTL_SEND_RST;
                    end else begin
                        ctl_sta <= CTL_READ_RAM;
                    end
                end else begin
                    bit_sel <= bit_sel + 1'b1;
                end
            end else begin
                bit_rdy <= 1'b0;
            end
        CTL_SEND_RST:
            if (code_cnt == CNT_50_US) begin
                ctl_sta <= CTL_INIT;
            end else begin
                code_cnt <= code_cnt + 1'b1;
            end
        endcase
    end
end

endmodule
