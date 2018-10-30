`define CLK 2//200MHz
`define Time51 `CLK*5100
module source_data(
	clk,
	Rst_n,//复位	
	out_data,//位输出数据
	rden_out,//ram读使能
	q,
	read,//读取触发脉冲
	tranLE,//位发送脉冲
	dataLE,//发送状态指示	
	trans,//发送指示
	adder,//读取地址
	addere,//调试用地址显示
	);
input clk,Rst_n,dataLE,read,q;
output out_data,tranLE,trans,adder,rden_out,addere;

wire [5:0]addere;
wire tranLE,da_rd,rden_out,read;
reg [1:0]mode;//mode=0准备等待，mode=1从ram中读取数据,mode=2按位发送数据,mode=3,51us计数
reg out_data,trans,rden,firstread,codeLE;
reg [5:0]adder;
wire [31:0]q;
reg [23:0]dataLED;
reg [4:0]count; //数据位计数使用
reg [15:0]cnt;//60us计数
reg [1:0]codeLE_temp;
reg [2:0]rden_temp;
/*--------------------------------------------------------*/
always@(posedge clk or negedge Rst_n)
if(!Rst_n)//复位
	begin
	cnt <= 16'b0;
	count <= 5'b0;
	mode <= 2'd00;
	trans <= 1'b0;
	end
else
	case(mode)
		2'b00:
		if(read == 1'b1)//接收到启动信号
			begin
			trans <= 1'b1;			
			rden <= 1'b0;	//读使能预备信号复位
			firstread <= 1'b1;//首次发送启动信号
			codeLE <= 1'b0;
			mode <= 2'b01;
			cnt <= 16'b0;
			adder <=6'b0;	//准备地址,从头读取 //aclr <= 1'b1;清零,			
			end
		2'b01:
			begin
			rden <= 1'b1;	//读使能预备信号
			if(da_rd)//锁存指示信号
				begin
				dataLED <= q[23:0];
				adder <= adder + 6'b1;
				count <= 5'b0;
				mode <= 2'b10;
				rden <= 1'b0;
				end
			end
		2'b10:
			if(firstread == 1'b1|| dataLE == 1'b1)
				begin
				firstread <= 1'b0;		
				out_data <= dataLED[5'd23 - count];//提取数据
				codeLE <= 1'b1;
				if(count == 5'd23)//计数
					begin
					count <= 5'b0;
				if(adder == 6'h00)//地址读取完成
						begin
						mode <= 2'b11;
						trans <= 1'b0;
						end
					else
						mode <= 2'b01;
					end					
				else
					count <= count + 1'b1;
				end
			else
				codeLE <= 1'b0;
		2'b11://51us计数
			if(cnt ==`Time51)
				begin
				cnt <= 16'b0;
				mode <= 2'b00;				
				end
			else
				begin
				cnt <= cnt + 1'b1;
				end
	endcase
/*---------------------------------------------------------------*/
always@( negedge clk or negedge Rst_n)//发送使能脉冲
if(!Rst_n)
	begin
	codeLE_temp <= 2'b0;
	rden_temp <= 3'b0;
	end
else
	begin
	codeLE_temp[0] <= codeLE;
	codeLE_temp[1] <= codeLE_temp[0];

	rden_temp[0] <= rden;
	rden_temp[1] <= rden_temp[0];
	rden_temp[2] <= rden_temp[1];
//	rden_temp[3] <= rden_temp[2];
	end
assign tranLE = codeLE_temp[0] & ~codeLE_temp[1];//上升沿脉冲 两个下降沿之间
assign rden_out = rden_temp[0] & ~rden_temp[1];//用于ram读使能
assign da_rd =rden_temp[1] & ~rden_temp[2];//用于数据读取判断
/*---------------------------------------------------------------*/
assign addere = q[29:24];
endmodule
