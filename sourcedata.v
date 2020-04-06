`define CLK_DIV     2
`define CNT_51_US   (`CLK_DIV * 5100)

module source_data(
    input wire clk_in,
    input wire rst_n_in,//复位	
    input wire [31:0] q,
    input wire read,//读取触发脉冲
    input wire dataLE,//发送状态指示	
  
    output wire tranLE,//位发送脉冲
    output wire out_data,//位输出数据
    output wire rden_out,//ram读使能
    output wire trans,//发送指示
    output wire [5:0] adder//读取地址
);

wire da_rd;
reg [1:0] state;//state=0准备等待，state=1从ram中读取数据,state=2按位发送数据,state=3,51us计数
reg rden, firstread, codeLE;

reg [23:0] dataLED;
reg [4:0] count; //数据位计数使用
reg [15:0] cnt;//60us计数
reg [1:0] codeLE_temp;
reg [2:0] rden_temp;

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        cnt <= 16'b0;
        count <= 5'b0;
        state <= 2'd00;
        trans <= 1'b0;
    end else begin
        case (state)
        2'b00:
            if (read == 1'b1) begin//接收到启动信号
                trans <= 1'b1;			
                rden <= 1'b0;	//读使能预备信号复位
                firstread <= 1'b1;//首次发送启动信号
                codeLE <= 1'b0;
                state <= 2'b01;
                cnt <= 16'b0;
                adder <=6'b0;	//准备地址,从头读取 //aclr <= 1'b1;清零,			
            end
        2'b01: begin
            rden <= 1'b1;	//读使能预备信号
            if (da_rd) begin //锁存指示信号
                dataLED <= q[23:0];
                adder <= adder + 6'b1;
                count <= 5'b0;
                state <= 2'b10;
                rden <= 1'b0;
            end
        end
        2'b10:
            if(firstread == 1'b1 || dataLE == 1'b1) begin
                firstread <= 1'b0;		
                out_data <= dataLED[5'd23 - count];//提取数据
                codeLE <= 1'b1;
                if (count == 5'd23) begin//计数
                    count <= 5'b0;
                    if (adder == 6'h00) begin//地址读取完成
                        state <= 2'b11;
                        trans <= 1'b0;
                    end else begin
                        state <= 2'b01;
                    end
                end else begin
                    count <= count + 1'b1;
                end
            end else begin
                codeLE <= 1'b0;
            end
        2'b11: //51us计数
            if (cnt ==`CNT_51_US) begin
                cnt <= 16'b0;
                state <= 2'b00;				
            end else begin
                cnt <= cnt + 1'b1;
            end
        endcase
    end
end

always @(negedge clk_in or negedge rst_n_in) //发送使能脉冲
begin
    if (!rst_n_in) begin
        codeLE_temp <= 2'b0;
        rden_temp <= 3'b0;
    end else begin
        codeLE_temp[0] <= codeLE;
        codeLE_temp[1] <= codeLE_temp[0];

        rden_temp[0] <= rden;
        rden_temp[1] <= rden_temp[0];
        rden_temp[2] <= rden_temp[1];
    end
end

assign tranLE = codeLE_temp[0] & ~codeLE_temp[1];//上升沿脉冲 两个下降沿之间
assign rden_out = rden_temp[0] & ~rden_temp[1];//用于ram读使能
assign da_rd =rden_temp[1] & ~rden_temp[2];//用于数据读取判断

endmodule
