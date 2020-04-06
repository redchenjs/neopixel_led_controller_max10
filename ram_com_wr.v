`define CUBE0414_ADDR_WR 8'hcc
`define CUBE0414_DATA_WR 8'hda

module RAM_COM_WR(
	input wire clk_in,//系统时钟，350MHz
    input wire rst_n_in,  //全局复位	
	input wire dc_in,//数据命令
	input wire ram_wr_en_in,//RAM写入使能
	input wire [7:0] spi_data_in,//缓存数据
	output wire [7:0] layer_en_out,//写入使能
	output wire [5:0] ram_wr_addr_out,//地址
	output wire [3:0] byte_en_out,//字节使能
	output wire read_en_out
);

reg	[7:0] layer;//层地址，八层
reg	[5:0] addre;//ram地址0~63

reg	addr_en;
reg	[2:0] byte_en;//2~0字节使能

reg read_en;
reg [1:0] read_en_temp;



idx2addr idx2addr(
    .clk_in(clk_in),
	.rst_n_in(rst_n_in),
    .en_in(addr_en),
	.idx_in(addre),
	.addr_out(ram_wr_addr_out)
);
/*---------------------------------------------------------*///写数据命令
always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        addr_en <= 1'b0;
        layer <= 8'd0;
        addre <= 6'b0;
    end else if(ram_wr_en_in == 1'b1) begin
        case (dc_in)
        1'b0: begin
            addre <= 6'b0;
            read_en <= 1'b0;//禁止读取
            case (spi_data_in)
                `CUBE0414_ADDR_WR: begin // Write RAM Address
                    addr_en <= 1'b1;
                    layer <= 8'hff;//所有层一起写入
                    byte_en <= 3'b000; addr_en <= 1'b1;//写入最高位，其余禁用
                end
                `CUBE0414_DATA_WR: begin // Write RAM Data
                    addr_en <= 1'b0;
                    layer <= 8'd1;				
                    byte_en <= 3'b100; addr_en <= 1'b0;//从次高位写入，最高位禁用				
                end
            endcase
        end
        1'b1:	
            if (addr_en == 1'b1) begin			
                addre <= addre + 6'd1;			
                if (addre == 6'd63) begin//全部写入完成
                    layer <= 8'd0;
                end
            end else begin		
                byte_en <= {byte_en[0], byte_en[2:1]};//循环右移
                if (byte_en == 3'b001) begin
                    addre <= addre + 6'd1;
                end
                
                if (byte_en == 3'b001 && addre == 6'd63 && layer != 8'h80) begin//层数加一
                    layer<= {layer[6:0], layer[7]};	//循环左移	
                end
                    
                if (byte_en == 3'b001 && addre == 6'd63 && layer == 8'h80) begin//全部写入完成
                    layer <= 8'd0;
                    read_en <= 1'b1;//开始读取
                end
            end
        endcase
	end
end

assign layer_en_out = layer & {ram_wr_en_in, ram_wr_en_in, ram_wr_en_in, ram_wr_en_in, ram_wr_en_in, ram_wr_en_in, ram_wr_en_in, ram_wr_en_in};//分别控制每一层的读使能
assign byte_en_out = {addr_en, byte_en};//最高字节禁止访问

always @(negedge clk_in or negedge rst_n_in)//发送使能脉冲
begin
    if (!rst_n_in) begin
        read_en_temp <=2'b0;
    end else begin
        read_en_temp[0] <= read_en;
        read_en_temp[1] <= read_en_temp[0];
    end
end

assign read_en_out = read_en_temp[0] & ~read_en_temp[1];//上升沿脉冲 两个下降沿之间

endmodule
