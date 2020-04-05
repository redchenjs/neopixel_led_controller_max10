module ws2812_led_controller(
    input clk_in,
    input rst_n_in,
    input spi_sclk_in,
    input spi_mosi_in,
    input spi_cs_in,
    input dc_in,
    output [7:0] ws2812_out
);

wire [7:0]outdata,layer;
wire [5:0]wraddress;
wire [3:0]byte;
wire locked,outclk,dc_out,read_en,spi_write,transl;

supply0 areset;

PLL PLL(
	.areset(areset),
	.inclk0(clk_in),
	.c0(c0),
	.locked(locked),
);

globalclk globalclk(
	.inclk(c0),
	.ena(locked), 
	.outclk(outclk),
);
/*--------------------------------------------------*/
SPI_MOSI SPI_MOSI(
	.SCLK(outclk),//系统时钟，200MHz
	.SPI_CLK(spi_sclk_in),
	.SPI_DATA(spi_mosi_in),
	.LE(spi_cs_in),//高电平使能
	.write(spi_write),//RAM写入使能
	.SHIFT_REG(outdata),
	.DC_in(dc_in),//命令数据线
	.DC_out(dc_out),//命令数据信号锁存
	.Rst_n(locked),  //全局复位
);
RAM_COM_WR RAM_COM_WR(
	.SCLK(outclk),
	.Rst_n(locked),  //全局复位
	.DC(dc_out),//数据命令
	.write(spi_write),//RAM写入使能
	.SHIFT_REG(outdata),//缓存数据
	.layer_en(layer),//写入使能
	.wraddre(wraddress),//地址
	.byte_en(byte),//字节使能
	.read(read_en),//读取控制
	.trans(transl),
);
/*---------------------------------------------------*/
trans layer0(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[0]),
	.zerodata(ws2812_out[0]),
	.transl(transl),
);
trans layer1(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[1]),
	.zerodata(ws2812_out[1]),
);
trans layer2(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[2]),
	.zerodata(ws2812_out[2]),
);
trans layer3(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[3]),
	.zerodata(ws2812_out[3]),
);
trans layer4(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[4]),
	.zerodata(ws2812_out[4]),
);
trans layer5(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[5]),
	.zerodata(ws2812_out[5]),
);
trans layer6(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[6]),
	.zerodata(ws2812_out[6]),
);
trans layer7(
	.clk(outclk),		//高速计时时钟
	.Rst_n(locked),	//全局复位，低电平复位
	.read(read_en),		//读取触发脉冲
	.spi_data(outdata),
	.byte(byte),
	.wraddress(wraddress),
	.wren(layer[7]),
	.zerodata(ws2812_out[7]),
);

endmodule
