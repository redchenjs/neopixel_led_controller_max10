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
    input wire ram_rd_en_in,
    input wire [31:0] ram_data_in,

    output wire bit_rdy_out,
    output wire bit_data_out,
    output wire ram_rd_en_out,
    output wire [5:0] ram_rd_addr_out
);

parameter [15:0] CNT_51_US = 2 * 5100;

parameter [1:0] STA_INIT = 2'b00;   // Init
parameter [1:0] STA_READ = 2'b01;   // Read Data From RAM
parameter [1:0] STA_SEND = 2'b10;   // Send Data Bit
parameter [1:0] STA_WAIT = 2'b11;   // Wait 51 us

reg [1:0] state = STA_INIT;

reg [4:0] bit_sel = 5'h00;
reg [15:0] wait_cnt = 16'h0000;
reg [23:0] ram_data = 24'h000000;

reg ram_rd_en = 1'b0, rd_start = 1'b0, bit_rdy = 1'b0;

reg [1:0] bit_rdy_pul  = 2'b00;
reg [2:0] ram_rd_en_pul = 2'b000;

assign bit_rdy_out = bit_rdy_pul[0] & ~bit_rdy_pul[1];          // Rising Edge Pulse
assign ram_rd_en_out = ram_rd_en_pul[0] & ~ram_rd_en_pul[1];    // Rising Edge Pulse

wire ram_rd_done;

assign ram_rd_done = ram_rd_en_pul[1] & ~ram_rd_en_pul[2];      // Rising Edge Pulse

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        state <= STA_INIT;

        wait_cnt <= 16'h0000;
        bit_sel <= 5'b0;
    end else begin
        case (state)
        STA_INIT:
            if (ram_rd_en_in) begin
                state <= STA_READ;

                bit_rdy <= 1'b0;
                rd_start <= 1'b1;
                ram_rd_en <= 1'b0;

                wait_cnt <= 16'h0000;

                ram_rd_addr_out <= 6'h00;
            end
        STA_READ: begin
            ram_rd_en <= 1'b1;

            if (ram_rd_done) begin
                state <= STA_SEND;
                
                bit_sel <= 5'b0;
                ram_rd_en <= 1'b0;
                
                ram_data <= ram_data_in[23:0];
                ram_rd_addr_out <= ram_rd_addr_out + 6'b1;
            end
        end
        STA_SEND:
            if (rd_start || bit_done_in) begin
                rd_start <= 1'b0;

                bit_rdy <= 1'b1;
                bit_data_out <= ram_data[5'd23 - bit_sel];//提取数据

                if (bit_sel == 5'd23) begin
                    bit_sel <= 5'b0;

                    if (ram_rd_addr_out == 6'h00) begin
                        state <= STA_WAIT;
                    end else begin
                        state <= STA_READ;
                    end
                end else begin
                    bit_sel <= bit_sel + 1'b1;
                end
            end else begin
                bit_rdy <= 1'b0;
            end
        STA_WAIT:
            if (wait_cnt == CNT_51_US) begin
                state <= STA_INIT;

                wait_cnt <= 16'h0000;
            end else begin
                wait_cnt <= wait_cnt + 1'b1;
            end
        endcase
    end
end

always @(negedge clk_in or negedge rst_n_in) //发送使能脉冲
begin
    if (!rst_n_in) begin
        bit_rdy_pul <= 2'b0;

        ram_rd_en_pul <= 3'b0;
    end else begin
        bit_rdy_pul[0] <= bit_rdy;
        bit_rdy_pul[1] <= bit_rdy_pul[0];

        ram_rd_en_pul[0] <= ram_rd_en;
        ram_rd_en_pul[1] <= ram_rd_en_pul[0];
        ram_rd_en_pul[2] <= ram_rd_en_pul[1];
    end
end

endmodule
