module ledtop(
	inclk,
	SPI_CLK,
	data,
	le,//高电平使能
	DC,
	zerodata,
	spi_write,
//	rdaddres
);

input inclk,SPI_CLK,data,le,DC;
output zerodata,spi_write;//,rdaddres,

wire [7:0]outdata,layer;
wire [7:0]zerodata;
wire [5:0]wraddress;
wire [3:0]byte;
wire locked,outclk,DC_out,read_en,spi_write,transl;
//wire [5:0]rdaddres;

supply0 areset;

PLL PLL (
	.areset(areset),
	.inclk0(inclk),
	.c0(c0),
	.locked(locked)
	);

globalclk globalclk (
	.inclk(c0),
	.ena(locked), 
	.outclk(outclk)
	);
/*--------------------------------------------------*/
SPI_MOSI SPI_MOSI(
	.SCLK(outclk),//系统时钟，200MHz
	.SPI_CLK(SPI_CLK),
	.SPI_DATA(data),
	.LE(le),//高电平使能
	.write(spi_write),//RAM写入使能
	.SHIFT_REG(outdata),
	.DC_in(DC),//命令数据线
	.DC_out(DC_out),//命令数据信号锁存
	.Rst_n(locked)  //全局复位
);
RAM_COM_WR RAM_COM_WR(
	.SCLK(outclk),
	.Rst_n(locked),  //全局复位
	.DC(DC_out),//数据命令
	.write(spi_write),//RAM写入使能
	.SHIFT_REG(outdata),//缓存数据
	.layer_en(layer),//写入使能
	.wraddre(wraddress),//地址
	.byte_en(byte),//字节使能
	.read(read_en),//读取控制
	.trans(transl)
);
/*---------------------------------------------------*/
trans trans0(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[0]),
	.zerodata(zerodata[0]),
	.transl(transl),
//	.addere(rdaddres)//调试用地址显示
);
trans trans1(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[1]),
	.zerodata(zerodata[1]),
);
trans trans2(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[2]),
	.zerodata(zerodata[2]),
);
trans trans3(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[3]),
	.zerodata(zerodata[3]),
);
trans trans4(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[4]),
	.zerodata(zerodata[4]),
);
trans trans5(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[5]),
	.zerodata(zerodata[5]),
);
trans trans6(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[6]),
	.zerodata(zerodata[6]),
);
trans trans7(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[7]),
	.zerodata(zerodata[7]),
);

endmodule
