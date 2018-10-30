module addrewr(
	number,
	wraddre,
	EN,
	Rst_n	
);
input number,EN,Rst_n;
output wraddre;

wire 	EN,Rst_n;
wire	[5:0]number;
reg	[5:0]wraddre;
reg	[5:0]addre[0:63];

//assign wraddre = addre[number];

always@ (*)
begin
if(!Rst_n)
	begin
addre[0]<=6'h00;
addre[1]<=6'h01;
addre[2]<=6'h02;
addre[3]<=6'h03;
addre[4]<=6'h04;
addre[5]<=6'h05;
addre[6]<=6'h06;
addre[7]<=6'h07;
addre[8]<=6'h0F;
addre[9]<=6'h0E;
addre[10]<=6'h0D;
addre[11]<=6'h0C;
addre[12]<=6'h0B;
addre[13]<=6'h0A;
addre[14]<=6'h09;
addre[15]<=6'h08;
addre[16]<=6'h10;
addre[17]<=6'h11;
addre[18]<=6'h12;
addre[19]<=6'h13;
addre[20]<=6'h14;
addre[21]<=6'h15;
addre[22]<=6'h16;
addre[23]<=6'h17;
addre[24]<=6'h1F;
addre[25]<=6'h1E;
addre[26]<=6'h1D;
addre[27]<=6'h1C;
addre[28]<=6'h1B;
addre[29]<=6'h1A;
addre[30]<=6'h19;
addre[31]<=6'h18;
addre[32]<=6'h20;
addre[33]<=6'h21;
addre[34]<=6'h22;
addre[35]<=6'h23;
addre[36]<=6'h24;
addre[37]<=6'h25;
addre[38]<=6'h26;
addre[39]<=6'h27;
addre[40]<=6'h2F;
addre[41]<=6'h2E;
addre[42]<=6'h2D;
addre[43]<=6'h2C;
addre[44]<=6'h2B;
addre[45]<=6'h2A;
addre[46]<=6'h29;
addre[47]<=6'h28;
addre[48]<=6'h30;
addre[49]<=6'h31;
addre[50]<=6'h32;
addre[51]<=6'h33;
addre[52]<=6'h34;
addre[53]<=6'h35;
addre[54]<=6'h36;
addre[55]<=6'h37;
addre[56]<=6'h3F;
addre[57]<=6'h3E;
addre[58]<=6'h3D;
addre[59]<=6'h3C;
addre[60]<=6'h3B;
addre[61]<=6'h3A;
addre[62]<=6'h39;
addre[63]<=6'h38;
end
else
	case(EN)
	1'b1://写入数据
	wraddre <= addre[number];
/*	1'b0://写入指针,8层同时
//	wraddre <= number;
	wraddre <= addre[number];*/
	endcase
end
endmodule
