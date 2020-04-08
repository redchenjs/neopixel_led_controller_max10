/*
 * ws2812_ctl.v
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_ctl(
    input wire clk_in,
    input wire rst_n_in,

    input wire bit_done_in,
    input wire layer_en_in,
    input wire frame_rdy_in,
    input wire [5:0] wr_addr_in,
    input wire [3:0] byte_en_in,
    input wire [7:0] byte_data_in,

    output wire bit_rdy_out,
    output wire bit_data_out
);

parameter [15:0] CNT_51_US = 2 * 5100;

parameter [1:0] CTL_INIT = 2'b00;   // Init
parameter [1:0] CTL_READ = 2'b01;   // Read Data Bit
parameter [1:0] CTL_SEND = 2'b10;   // Send Data Bit
parameter [1:0] CTL_WAIT = 2'b11;   // Wait

reg bit_rdy;
reg [4:0] bit_sel;

reg ram_rd_en;
reg ram_rd_init;
reg [5:0] ram_rd_addr;
reg [31:0] ram_rd_data;

reg [1:0] ctl_sta;
reg [15:0] wait_cnt;

reg [1:0] bit_rdy_pul;
assign bit_rdy_out = bit_rdy_pul[0] & ~bit_rdy_pul[1];          // Rising Edge Pulse

wire ram_rd_done;
reg [2:0] ram_rd_en_pul;
assign ram_rd_done = ram_rd_en_pul[1] & ~ram_rd_en_pul[2];      // Rising Edge Pulse

ram64 ram64(
    .byteena_a(byte_en_in),
    .clock(clk_in),
    .data({byte_data_in, byte_data_in, byte_data_in, byte_data_in}),
    .rdaddress(ram_rd_addr),
    .rden(ram_rd_en_pul[0] & ~ram_rd_en_pul[1]),
    .wraddress(wr_addr_in),
    .wren(layer_en_in),
    .q(ram_rd_data)
);

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        ctl_sta <= CTL_INIT;
    end else begin
        case (ctl_sta)
        CTL_INIT:
            if (frame_rdy_in) begin
                ctl_sta <= CTL_READ;

                bit_rdy <= 1'b0;
                bit_sel <= 5'h00;

                ram_rd_en <= 1'b0;
                ram_rd_init <= 1'b1;
                ram_rd_addr <= 6'h00;

                wait_cnt <= 16'h0000;
            end
        CTL_READ: begin
            if (ram_rd_done) begin
                ctl_sta <= CTL_SEND;

                ram_rd_addr <= ram_rd_data[29:24];

                ram_rd_en <= 1'b0;
            end else begin
                ram_rd_en <= 1'b1;
            end
        end
        CTL_SEND:
            if (ram_rd_init || bit_done_in) begin
                ram_rd_init <= 1'b0;

                bit_rdy <= 1'b1;
                bit_data_out <= ram_rd_data[5'd23 - bit_sel];

                if (bit_sel == 5'd23) begin
                    bit_sel <= 5'h00;

                    if (ram_rd_addr == 6'h00) begin
                        ctl_sta <= CTL_WAIT;
                    end else begin
                        ctl_sta <= CTL_READ;
                    end
                end else begin
                    bit_sel <= bit_sel + 1'b1;
                end
            end else begin
                bit_rdy <= 1'b0;
            end
        CTL_WAIT:
            if (wait_cnt == CNT_51_US) begin
                ctl_sta <= CTL_INIT;
            end else begin
                wait_cnt <= wait_cnt + 1'b1;
            end
        endcase
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        bit_rdy_pul <= 2'b00;

        ram_rd_en_pul <= 3'b000;
    end else begin
        bit_rdy_pul[0] <= bit_rdy;
        bit_rdy_pul[1] <= bit_rdy_pul[0];

        ram_rd_en_pul[0] <= ram_rd_en;
        ram_rd_en_pul[1] <= ram_rd_en_pul[0];
        ram_rd_en_pul[2] <= ram_rd_en_pul[1];
    end
end

endmodule
