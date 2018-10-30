module SPI_MOSI(
	SCLK,//系统时钟，200MHz
	SPI_CLK,
	SPI_DATA,
	LE,//高电平使能
	write,//RAM写入使能
	SHIFT_REG,
	DC_in,//命令数据线
	DC_out,
	Rst_n  //全局复位
)/*synthesis noprune*/;


input LE,SPI_CLK,SPI_DATA,SCLK,Rst_n,DC_in;
output write,SHIFT_REG,DC_out;

reg	[7:0]SHIFT_REG;//串口寄存器
reg	[3:0]cnt = 4'd0;//位数计数,初始化为111
reg	[1:0]cnt_sync = 2'b0;//两拍同步触发器
reg	[1:0]cnt_pulse;//脉冲产生触发器
reg	DC_out;
wire	write;//高电平有效
wire	L;
/*-------------------------------------------------------*/
assign L= !LE;
/*--------------------------------------------------------*/
always@(posedge SPI_CLK or negedge L)
begin
if(!L)
	cnt <= 4'd0;//重头写入寄存器
else
	begin
	SHIFT_REG <= {SHIFT_REG,SPI_DATA};
	cnt <= cnt + 4'b0001;
	if(cnt == 4'd1)//锁存命令数据信号
		DC_out <= DC_in;	
	if(cnt[3])
		cnt[3] <= 1'b0;			
	end
end		
/*--------------------------------------------------------*/		
always@(posedge SCLK or negedge Rst_n)
begin
if(!Rst_n)
	begin
		cnt_sync <= 2'b0;
	end
else
	begin
	cnt_sync[0] <= cnt[3];
	cnt_sync[1] <= cnt_sync[0];//异时钟域同步	
	end
end
/*---------------------------------------------------------*/
always@(negedge SCLK or negedge Rst_n)
begin
if(!Rst_n)
	begin
	cnt_pulse <= 2'b0;
	end
else
	begin
	cnt_pulse[0] <= cnt_sync[1];
	cnt_pulse[1] <= cnt_pulse[0];	
	end
end
assign write = cnt_pulse[0] & ~cnt_pulse[1];//上升沿使能（RAM写入使能）,一个时钟周期,两个下降沿之间
/*---------------------------------------------------------*/
endmodule
