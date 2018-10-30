module system_delay(//延迟启动模块
	clk,
	delay_ok);
 //-----------------------------------------
 // Delay 100ms for steady state

input clk; //50MHz
output delay_ok;

reg [22:0] cnt;

always@(posedge clk)
begin
if(cnt < 23'd50_00000) //100ms
cnt <= cnt + 1'b1;
else
cnt <= cnt;
end
//sys_rst_n synchronism
assign delay_ok = (cnt == 23'd50_00000)? 1'b1 : 1'b0;
endmodule
