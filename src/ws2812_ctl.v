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

wire data_rd;
reg [1:0] state;//state=0准备等待，state=1从ram中读取数据,state=2按位发送数据,state=3,51us计数
reg ram_rd_en, firstread, data_rdy;

reg [23:0] ram_data;
reg [4:0] count; //数据位计数使用
reg [15:0] cnt;//60us计数

reg [1:0] data_rdy_pul;
reg [2:0] ram_rd_en_pul;

assign bit_rdy_out = data_rdy_pul[0] & ~data_rdy_pul[1];        // Rising Edge Pulse
assign ram_rd_en_out = ram_rd_en_pul[0] & ~ram_rd_en_pul[1];    // Rising Edge Pulse
assign data_rd = ram_rd_en_pul[1] & ~ram_rd_en_pul[2];          // Rising Edge Pulse

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        cnt <= 16'b0;
        count <= 5'b0;
        state <= 2'd00;
    end else begin
        case (state)
        2'b00:
            if (ram_rd_en_in == 1'b1) begin//接收到启动信号	
                ram_rd_en <= 1'b0;	//读使能预备信号复位
                firstread <= 1'b1;//首次发送启动信号
                data_rdy <= 1'b0;
                state <= 2'b01;
                cnt <= 16'b0;
                ram_rd_addr_out <=6'b0;	//准备地址,从头读取 //aclr <= 1'b1;清零,			
            end
        2'b01: begin
            ram_rd_en <= 1'b1;	//读使能预备信号
            if (data_rd) begin //锁存指示信号
                ram_data <= ram_data_in[23:0];
                ram_rd_addr_out <= ram_rd_addr_out + 6'b1;
                count <= 5'b0;
                state <= 2'b10;
                ram_rd_en <= 1'b0;
            end
        end
        2'b10:
            if(firstread == 1'b1 || bit_done_in == 1'b1) begin
                firstread <= 1'b0;		
                bit_data_out <= ram_data[5'd23 - count];//提取数据
                data_rdy <= 1'b1;
                if (count == 5'd23) begin//计数
                    count <= 5'b0;
                    if (ram_rd_addr_out == 6'h00) begin//地址读取完成
                        state <= 2'b11;
                    end else begin
                        state <= 2'b01;
                    end
                end else begin
                    count <= count + 1'b1;
                end
            end else begin
                data_rdy <= 1'b0;
            end
        2'b11: //51us计数
            if (cnt == CNT_51_US) begin
                cnt <= 16'b0;
                state <= 2'b00;				
            end else begin
                cnt <= cnt + 1'b1;
            end
        endcase
    end
end

always @(negedge clk_in or negedge rst_n_in) //发送使能脉冲
begin
    if (!rst_n_in) begin
        data_rdy_pul <= 2'b0;
        ram_rd_en_pul <= 3'b0;
    end else begin
        data_rdy_pul[0] <= data_rdy;
        data_rdy_pul[1] <= data_rdy_pul[0];

        ram_rd_en_pul[0] <= ram_rd_en;
        ram_rd_en_pul[1] <= ram_rd_en_pul[0];
        ram_rd_en_pul[2] <= ram_rd_en_pul[1];
    end
end

endmodule
