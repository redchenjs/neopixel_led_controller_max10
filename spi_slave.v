module spi_slave(
	input wire clk_in,//系统时钟，200MHz
    input wire rst_n_in,  //全局复位
	input wire spi_sclk_in,
	input wire spi_mosi_in,
	input wire spi_cs_n_in,
    output wire ram_wr_en_out,
	output wire [7:0] spi_data_out
);

reg	[3:0]cnt = 4'd0;//位数计数,初始化为111
reg	[1:0]cnt_sync = 2'b0;//两拍同步触发器
reg	[1:0]cnt_pulse;//脉冲产生触发器

always @(posedge spi_sclk_in or negedge spi_cs_n_in)
begin
    if (!spi_cs_n_in) begin
        cnt <= 4'd0;
    end else begin
        spi_data_out <= {spi_data_out, spi_mosi_in};
        cnt <= cnt + 4'b0001;
        if (cnt[3]) begin
            cnt[3] <= 1'b0;
        end  
    end
end		

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        cnt_sync <= 2'b0;
    end else begin
        cnt_sync[0] <= cnt[3];
        cnt_sync[1] <= cnt_sync[0];//异时钟域同步	
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        cnt_pulse <= 2'b0;
    end else begin
        cnt_pulse[0] <= cnt_sync[1];
        cnt_pulse[1] <= cnt_pulse[0];	
    end
end

assign ram_wr_en_out = cnt_pulse[0] & ~cnt_pulse[1]; //上升沿使能（RAM写入使能）,一个时钟周期,两个下降沿之间

endmodule
