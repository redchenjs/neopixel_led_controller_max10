/*
 * idx2addr.v
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

//`define LED_S_CURVE

module idx2addr(
	input wire clk_in,
	input wire rst_n_in,
    
	input wire [5:0] idx_in,

	output wire [5:0] addr_out
);

reg	[5:0] data_addr [0:63];

initial begin
`ifdef LED_S_CURVE
    data_addr[0] <= 6'h00;
    data_addr[1] <= 6'h01;
    data_addr[2] <= 6'h02;
    data_addr[3] <= 6'h03;
    data_addr[4] <= 6'h04;
    data_addr[5] <= 6'h05;
    data_addr[6] <= 6'h06;
    data_addr[7] <= 6'h07;
    data_addr[8] <= 6'h0f;
    data_addr[9] <= 6'h0e;
    data_addr[10] <= 6'h0d;
    data_addr[11] <= 6'h0c;
    data_addr[12] <= 6'h0b;
    data_addr[13] <= 6'h0a;
    data_addr[14] <= 6'h09;
    data_addr[15] <= 6'h08;
    data_addr[16] <= 6'h10;
    data_addr[17] <= 6'h11;
    data_addr[18] <= 6'h12;
    data_addr[19] <= 6'h13;
    data_addr[20] <= 6'h14;
    data_addr[21] <= 6'h15;
    data_addr[22] <= 6'h16;
    data_addr[23] <= 6'h17;
    data_addr[24] <= 6'h1f;
    data_addr[25] <= 6'h1e;
    data_addr[26] <= 6'h1d;
    data_addr[27] <= 6'h1c;
    data_addr[28] <= 6'h1b;
    data_addr[29] <= 6'h1a;
    data_addr[30] <= 6'h19;
    data_addr[31] <= 6'h18;
    data_addr[32] <= 6'h20;
    data_addr[33] <= 6'h21;
    data_addr[34] <= 6'h22;
    data_addr[35] <= 6'h23;
    data_addr[36] <= 6'h24;
    data_addr[37] <= 6'h25;
    data_addr[38] <= 6'h26;
    data_addr[39] <= 6'h27;
    data_addr[40] <= 6'h2f;
    data_addr[41] <= 6'h2e;
    data_addr[42] <= 6'h2d;
    data_addr[43] <= 6'h2c;
    data_addr[44] <= 6'h2b;
    data_addr[45] <= 6'h2a;
    data_addr[46] <= 6'h29;
    data_addr[47] <= 6'h28;
    data_addr[48] <= 6'h30;
    data_addr[49] <= 6'h31;
    data_addr[50] <= 6'h32;
    data_addr[51] <= 6'h33;
    data_addr[52] <= 6'h34;
    data_addr[53] <= 6'h35;
    data_addr[54] <= 6'h36;
    data_addr[55] <= 6'h37;
    data_addr[56] <= 6'h3f;
    data_addr[57] <= 6'h3e;
    data_addr[58] <= 6'h3d;
    data_addr[59] <= 6'h3c;
    data_addr[60] <= 6'h3b;
    data_addr[61] <= 6'h3a;
    data_addr[62] <= 6'h39;
    data_addr[63] <= 6'h38;
`else
    data_addr[0] <= 6'h00;
    data_addr[1] <= 6'h01;
    data_addr[2] <= 6'h02;
    data_addr[3] <= 6'h03;
    data_addr[4] <= 6'h04;
    data_addr[5] <= 6'h05;
    data_addr[6] <= 6'h06;
    data_addr[7] <= 6'h07;
    data_addr[8] <= 6'h08;
    data_addr[9] <= 6'h09;
    data_addr[10] <= 6'h0a;
    data_addr[11] <= 6'h0b;
    data_addr[12] <= 6'h0c;
    data_addr[13] <= 6'h0d;
    data_addr[14] <= 6'h0e;
    data_addr[15] <= 6'h0f;
    data_addr[16] <= 6'h10;
    data_addr[17] <= 6'h11;
    data_addr[18] <= 6'h12;
    data_addr[19] <= 6'h13;
    data_addr[20] <= 6'h14;
    data_addr[21] <= 6'h15;
    data_addr[22] <= 6'h16;
    data_addr[23] <= 6'h17;
    data_addr[24] <= 6'h18;
    data_addr[25] <= 6'h19;
    data_addr[26] <= 6'h1a;
    data_addr[27] <= 6'h1b;
    data_addr[28] <= 6'h1c;
    data_addr[29] <= 6'h1d;
    data_addr[30] <= 6'h1e;
    data_addr[31] <= 6'h1f;
    data_addr[32] <= 6'h20;
    data_addr[33] <= 6'h21;
    data_addr[34] <= 6'h22;
    data_addr[35] <= 6'h23;
    data_addr[36] <= 6'h24;
    data_addr[37] <= 6'h25;
    data_addr[38] <= 6'h26;
    data_addr[39] <= 6'h27;
    data_addr[40] <= 6'h28;
    data_addr[41] <= 6'h29;
    data_addr[42] <= 6'h2a;
    data_addr[43] <= 6'h2b;
    data_addr[44] <= 6'h2c;
    data_addr[45] <= 6'h2d;
    data_addr[46] <= 6'h2e;
    data_addr[47] <= 6'h2f;
    data_addr[48] <= 6'h30;
    data_addr[49] <= 6'h31;
    data_addr[50] <= 6'h32;
    data_addr[51] <= 6'h33;
    data_addr[52] <= 6'h34;
    data_addr[53] <= 6'h35;
    data_addr[54] <= 6'h36;
    data_addr[55] <= 6'h37;
    data_addr[56] <= 6'h38;
    data_addr[57] <= 6'h39;
    data_addr[58] <= 6'h3a;
    data_addr[59] <= 6'h3b;
    data_addr[60] <= 6'h3c;
    data_addr[61] <= 6'h3d;
    data_addr[62] <= 6'h3e;
    data_addr[63] <= 6'h3f;
`endif
end

always @(posedge clk_in)
begin
    addr_out <= data_addr[idx_in];
end

endmodule
