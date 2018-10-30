module trans(
	clk,		//高速计时时钟
	Rst_n,	//全局复位，低电平复位
	read,		//读取触发脉冲
	spi_data,
	byte,
	wraddress,
	wren,
	zerodata,
	transl,
	addere//调试用地址显示
);

input clk,Rst_n,read,byte,spi_data,wraddress,wren;
output zerodata,transl,addere;

wire [3:0]byte;
wire [7:0]spi_data;
wire [5:0]wraddress,addere,rdaddres;//
wire rden,wren,aclr;
wire dataLE,tranLE,out_data;
wire [31:0]q;

ram64 ram (
	.byteena_a(byte),
	.clock(clk),
	.data({spi_data,spi_data,spi_data,spi_data}),
	.rdaddress(rdaddres),
	.rden(rden),
	.wraddress(wraddress),
	.wren(wren),
	.q(q),
);
source_data source_data(
	.clk(clk),
	.Rst_n(Rst_n),//复位	
	.out_data(out_data),//位数据(输出)	
	.rden_out(rden),//ram读使能
	.q(q),
	.read(read),//读取触发脉冲
	.tranLE(tranLE),//位发送脉冲(输出)
	.dataLE(dataLE),//发送状态指示(输入)
	.trans(transl),//发送指示	
	.addere(addere),//调试用地址显示
	.adder(rdaddres),
);
code0_1 code0_1(
	.clk(clk),		//高速计时时钟
	.Rst_n(Rst_n),	//全局复位，低电平复位
	.indata(out_data),//(输入)	
	.outdata(zerodata),//归零码(输出)
	.inLE(tranLE),		//使能信号脉冲上升沿有效(输入)
	.dataLE(dataLE)	//发送完成后传输一个脉冲(输出)
);

endmodule
