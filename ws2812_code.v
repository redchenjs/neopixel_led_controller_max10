`define CLK 2//200MHz
`define Time1350 `CLK*135
`define Time350 `CLK*35
`define Time1700 `CLK*(170-2)
module ws2812_code(
		clk,		//高速计时时钟
		Rst_n,	//全局复位，低电平复位
		indata,	
		outdata,
		inLE,		//使能信号脉冲上升沿有效
		dataLE	//发送完成后传输一个脉冲
);

input clk,indata,inLE,Rst_n;
output outdata,dataLE;

wire dataLE;
reg [1:0]temp_mode;
reg outdata;
reg mode;//mode=1发送状态，mode=0空闲状态
reg [8:0]cnt;	//定义计数器寄存器
reg [8:0]down;//定义归零时间

always@(posedge clk or negedge Rst_n)

if(!Rst_n)//判断全局复位
	begin
	cnt <= 9'b0;
	outdata <=1'b0;//输出低电平
	mode <= 1'b0;//处于空闲状态
	end
else if(inLE == 1'b1)//收到脉冲信号
	mode <= 1'b1;	
else
	if(mode == 1'b1)//处于发送状态		
		if(cnt == `Time1700)
			begin
			cnt <= 9'b0;
			mode <= 1'b0;//发送完成，处于空闲状态
			end
		else if(cnt >= down)
		begin
			outdata <=1'b0;//输出低电平
			cnt <= cnt + 1'b1;
		end
		else		
			if(cnt == 9'b0)
				begin
				outdata <=1'b1;//输出高电平
				cnt <= cnt + 1'b1;			
				if(indata)//1归零码
					down <= `Time1350;
				else//0归零码
					down <= `Time350;			
				end
			else
			cnt <= cnt + 1'b1;
	else//即mode==0
		begin//处于空闲状态
		cnt <= 9'b0;//停止发送，复位	
		outdata <=1'b0;//输出低电平
		mode <= 1'b0;
		end
/*------------------------------------------------------------*/
always@( negedge clk or negedge Rst_n)
if(!Rst_n)
	begin
	temp_mode <= 2'b0;
	end
else
	begin
	temp_mode[0] <= mode;
	temp_mode[1] <= temp_mode[0];
	end
assign dataLE = ~temp_mode[0] & temp_mode[1];//下降沿脉冲
/*-------------------------------------------------------------*/
endmodule
