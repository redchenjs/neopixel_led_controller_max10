/*
 * ws2812_out.v
 *
 *  Created on: 2020-04-06 23:09
 *      Author: Jack Chen <redchenjs@live.com>
 */

module ws2812_out(
    input wire clk_in,
    input wire rst_n_in,	

    input wire bit_rdy_in,
    input wire bit_data_in,	

    output wire bit_done_out,
    output wire ws2812_data_out
);

parameter [8:0] CNT_0_35_US = 2 * 35;
parameter [8:0] CNT_1_35_US = 2 * 135;
parameter [8:0] CNT_1_70_US = 2 * 170;

reg state;//state=1发送状态，state=0空闲状态
reg [8:0]cnt;	//定义计数器寄存器
reg [8:0]down;//定义归零时间

reg [1:0] bit_done_pul;

assign bit_done_out = ~bit_done_pul[0] & bit_done_pul[1];   // Falling Edge Pulse

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        cnt <= 9'b0;
        ws2812_data_out <=1'b0;//输出低电平
        state <= 1'b0;//处于空闲状态
    end else if (bit_rdy_in == 1'b1) begin//收到脉冲信号
        state <= 1'b1;
    end else begin
        if (state == 1'b1) begin//处于发送状态		
            if (cnt == CNT_1_70_US) begin
                cnt <= 9'b0;
                state <= 1'b0;//发送完成，处于空闲状态
            end else if(cnt >= down) begin
                ws2812_data_out <=1'b0;//输出低电平
                cnt <= cnt + 1'b1;
            end else if(cnt == 9'b0) begin
                    ws2812_data_out <= 1'b1;//输出高电平
                    cnt <= cnt + 1'b1;			
                    if (bit_data_in) begin//1归零码
                        down <= CNT_1_35_US;
                    end else begin//0归零码
                        down <= CNT_0_35_US;			
                    end
            end else begin
                cnt <= cnt + 1'b1;
            end
        end else begin//即state==0
            //处于空闲状态
            cnt <= 9'b0;//停止发送，复位	
            ws2812_data_out <=1'b0;//输出低电平
            state <= 1'b0;
        end
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        bit_done_pul <= 2'b0;
    end else begin
        bit_done_pul[0] <= state;
        bit_done_pul[1] <= bit_done_pul[0];
    end
end

endmodule
