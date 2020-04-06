/*
 * spi_slave.v
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module spi_slave(
	input wire clk_in,
    input wire rst_n_in,
    
	input wire spi_sclk_in,
	input wire spi_mosi_in,
	input wire spi_cs_n_in,

    output wire spi_rdy_out,
	output wire [7:0] spi_data_out
);

reg	[3:0]cnt = 4'd0;        // 位数计数

reg	[1:0] spi_rdy_syn = 2'b0;    // 两拍同步触发器
reg	[1:0] spi_rdy_pul = 2'b0;    // 脉冲产生触发器

assign spi_rdy_out = spi_rdy_pul[0] & ~spi_rdy_pul[1];  // Rising Edge Pulse

always @(posedge spi_sclk_in)
begin
    if (!spi_cs_n_in) begin
        spi_data_out <= {spi_data_out, spi_mosi_in};
        cnt <= cnt + 4'b0001;
        if (cnt[3]) begin
            cnt[3] <= 1'b0;
        end
    end else begin
        cnt <= 4'd0;
    end
end

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        spi_rdy_syn <= 2'b0;
    end else begin
        spi_rdy_syn[0] <= cnt[3];
        spi_rdy_syn[1] <= spi_rdy_syn[0];   // 异时钟域同步	
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        spi_rdy_pul <= 2'b0;
    end else begin
        spi_rdy_pul[0] <= spi_rdy_syn[1];
        spi_rdy_pul[1] <= spi_rdy_pul[0];	
    end
end

endmodule
