module RAM_COM_WR(
	SCLK,//系统时钟，350MHz
	DC,//数据命令
	write,//RAM写入使能
	SHIFT_REG,//缓存数据
	layer_en,//写入使能
	wraddre,//地址
	byte_en,//字节使能
	read,//读取控制
	trans,//发送指示，高电平禁止写入
	Rst_n  //全局复位	
);

input write,SHIFT_REG,Rst_n,DC,SCLK,trans;
output layer_en,wraddre,byte_en,read;
wire	[5:0]wraddre;
wire	[7:0]SHIFT_REG;
reg	[7:0]layer;//层地址，八层
reg	[5:0]addre;//ram地址0~63
reg	[2:0]byte;//2~0字节使能
reg	EN;//写入状态指示
reg	byte3;//最高位字节
wire	[3:0]byte_en;//字节使能输出
wire	[7:0]layer_en;//每层的写入使能
reg 	read_en;
reg 	[1:0]read_en_temp;
wire	read,trans;
/*---------------------------------------------------------*/
addrewr addrewr(
	.number(addre),
	.wraddre(wraddre),
	.EN(EN),
	.Rst_n(Rst_n)
);
/*---------------------------------------------------------*///写数据命令
always@(posedge SCLK or negedge Rst_n)
begin
if(!Rst_n)
	begin
	EN <=2'b00;
	layer <= 8'd0;
	addre <= 6'b0;
	end

else if(write == 1'b1)
	begin
	case ({DC,trans})
	2'b00:
		begin
		addre <= 6'b0;
		read_en <= 1'b0;//禁止读取
		case (SHIFT_REG)
			8'hda://写入数据命令
				begin
				EN <=1'b1;
				layer <= 8'd1;				
				byte <= 3'b100;byte3 <= 1'b0;//从次高位写入，最高位禁用				
				end
/*			8'hcc://写入指针命令
				begin
				EN <=1'b0;
				layer <= 8'hff;//所有层一起写入
				byte <= 3'b000;byte3 <= 1'b1;//写入最高位，其余禁用
				end*/
		endcase
		end
	2'b10:	
		case(EN)		
			1'b1://写入数据
				begin			
				byte <= {byte[0],byte[2:1]};//循环右移
				if(byte == 3'b001)
					addre <= addre + 6'd1;
				if(byte == 3'b001 && addre == 6'd63 && layer != 8'h80)//层数加一
					layer<= {layer[6:0],layer[7]};	//循环左移				
				if(byte == 3'b001 && addre == 6'd63 && layer == 8'h80)//全部写入完成
					begin
					layer <= 8'd0;
					read_en <= 1'b1;//开始读取
					end
				end
/*			1'b0://写入指针,8层同时
				begin			
				addre <= addre + 6'd1;			
				if(addre == 6'd63)//全部写入完成
					begin
					layer <= 8'd0;
					end
				end*/
		endcase
	endcase
	end
end
/*---------------------------------------------------------*/
assign	layer_en = layer & {write,write,write,write,write,write,write,write};//分别控制每一层的读使能
assign	byte_en = {byte3,byte};//最高字节禁止访问
/*---------------------------------------------------------*/
always@( negedge SCLK or negedge Rst_n)//发送使能脉冲
if(!Rst_n)
	read_en_temp <=2'b0;
else
	begin
	read_en_temp[0] <= read_en;
	read_en_temp[1] <= read_en_temp[0];
	end

assign read = read_en_temp[0] & ~read_en_temp[1];//上升沿脉冲 两个下降沿之间
/*---------------------------------------------------------------*/

endmodule
