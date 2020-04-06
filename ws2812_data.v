module ws2812_data(
	input wire clk_in,		//高速计时时钟
	input wire rst_n_in,	//全局复位，低电平复位
	input wire read_en_in,		//读取触发脉冲
	input wire [7:0] spi_data_in,
	input wire [3:0] byte_en_in,
	input wire [5:0] wraddress,
	input wire wren,
	output wire data_out,
	output wire transl
);

wire [5:0] rdaddres;//
wire rden, aclr;
wire dataLE, tranLE, out_data;
wire [31:0]q;

ram64 ram(
	.byteena_a(byte_en_in),
	.clock(clk_in),
	.data({spi_data_in, spi_data_in, spi_data_in, spi_data_in}),
	.rdaddress(rdaddres),
	.rden(rden),
	.wraddress(wraddress),
	.wren(wren),
	.q(q)
);

source_data source_data(
	.clk_in(clk_in),
	.rst_n_in(rst_n_in),//复位	
	.out_data(out_data),//位数据(输出)	
	.rden_out(rden),//ram读使能
	.q(q),
	.read(read_en_in),//读取触发脉冲
	.tranLE(tranLE),//位发送脉冲(输出)
	.dataLE(dataLE),//发送状态指示(输入)
	.trans(transl),//发送指示	
	.adder(rdaddres)
);

ws2812_code ws2812_code(
	.clk(clk_in),		//高速计时时钟
	.Rst_n(rst_n_in),	//全局复位，低电平复位
	.indata(out_data),//(输入)	
	.outdata(data_out),//归零码(输出)
	.inLE(tranLE),		//使能信号脉冲上升沿有效(输入)
	.dataLE(dataLE)	//发送完成后传输一个脉冲(输出)
);

endmodule
