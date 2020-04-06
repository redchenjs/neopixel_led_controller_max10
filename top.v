module ws2812_led_controller(
    input wire clk_in,
    input wire rst_n_in,
    input wire spi_sclk_in,
    input wire spi_mosi_in,
    input wire spi_cs_n_in,
    input wire dc_in,
    output wire [7:0] ws2812_data_out
);

wire [3:0] byte_en;
wire [7:0] layer_en;

wire ram_wr_en;
wire [7:0] spi_data;
wire [5:0] ram_wr_addr;

supply0 pll_rst;
wire pll_c0, pll_locked, sys_clk;

wire read_en;

PLL pll(
	.areset(pll_rst),
	.inclk0(clk_in),
	.c0(pll_c0),
	.locked(pll_locked)
);

globalclk globalclk(
	.inclk(pll_c0),
	.ena(pll_locked), 
	.outclk(sys_clk)
);

spi_slave spi_slave(
	.clk_in(sys_clk),
    .rst_n_in(pll_locked),
	.spi_sclk_in(spi_sclk_in),
	.spi_mosi_in(spi_mosi_in),
	.spi_cs_n_in(spi_cs_n_in),
    .spi_data_out(spi_data),
	.ram_wr_en_out(ram_wr_en)
);

RAM_COM_WR RAM_COM_WR(
	.clk_in(sys_clk),
	.rst_n_in(pll_locked),  //全局复位
	.dc_in(dc_in),//数据命令
	.ram_wr_en_in(ram_wr_en),//RAM写入使能
	.spi_data_in(spi_data),//缓存数据
	.layer_en_out(layer_en),//写入使能
	.ram_wr_addr_out(ram_wr_addr),//地址
	.byte_en_out(byte_en),//字节使能
	.read_en_out(read_en)//读取控制
);

ws2812_data layer0(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[0]),
	.data_out(ws2812_data_out[0])
);

ws2812_data layer1(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[1]),
	.data_out(ws2812_data_out[1])
);

ws2812_data layer2(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[2]),
	.data_out(ws2812_data_out[2])
);

ws2812_data layer3(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[3]),
	.data_out(ws2812_data_out[3])
);

ws2812_data layer4(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[4]),
	.data_out(ws2812_data_out[4])
);

ws2812_data layer5(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[5]),
	.data_out(ws2812_data_out[5])
);

ws2812_data layer6(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[6]),
	.data_out(ws2812_data_out[6])
);

ws2812_data layer7(
	.clk_in(sys_clk),		//高速计时时钟
	.rst_n_in(pll_locked),	//全局复位，低电平复位
	.read_en_in(read_en),		//读取触发脉冲
	.spi_data_in(spi_data),
	.byte_en_in(byte_en),
	.wraddress(ram_wr_addr),
	.wren(layer_en[7]),
	.data_out(ws2812_data_out[7])
);

endmodule
