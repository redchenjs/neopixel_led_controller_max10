`timescale 1ns /1ps

module test;

reg inclk,LE,data,SPI_CLK,DC;

ledtop ledtop(
	.inclk(inclk),
	.SPI_CLK(SPI_CLK),
	.data(data),
	.le(LE),//低电平使能
	.DC(DC),
	.zerodata(zerodata)
);

initial
begin 
inclk <= 0;
SPI_CLK <= 0;
end

initial
begin 
data <= 0;
LE <= 1;
DC <= 0;
#1250 LE<=0; //打开使能
	data <= 1;//0
#25 data <= 1;//1
#25 data <= 0;//2
#25 data <= 1;//3
#25 data <= 1;//4
#25 data <= 0;//5
#25 data <= 1;//6
#25 data <= 0;//7
#25 LE<=1; //关闭使能
 DC <= 1; //传输数据
#25 LE<=0; //打开使能
end

always
begin
#42 inclk <= ~inclk;
end

always
begin
#12.5 SPI_CLK <= ~SPI_CLK;
end
//$stop;

endmodule
