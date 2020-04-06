//`define LED_S_CURVE

module idx2addr(
	input wire clk_in,
	input wire rst_n_in,
    input wire en_in,
	input wire [5:0] idx_in,
	output wire [5:0] addr_out
);

reg	[5:0] led_addr [0:63];

always @(posedge clk_in)
begin
    if (!rst_n_in) begin
        `ifdef LED_S_CURVE
            led_addr[0] <= 6'h00;
            led_addr[1] <= 6'h01;
            led_addr[2] <= 6'h02;
            led_addr[3] <= 6'h03;
            led_addr[4] <= 6'h04;
            led_addr[5] <= 6'h05;
            led_addr[6] <= 6'h06;
            led_addr[7] <= 6'h07;
            led_addr[8] <= 6'h0F;
            led_addr[9] <= 6'h0E;
            led_addr[10] <= 6'h0D;
            led_addr[11] <= 6'h0C;
            led_addr[12] <= 6'h0B;
            led_addr[13] <= 6'h0A;
            led_addr[14] <= 6'h09;
            led_addr[15] <= 6'h08;
            led_addr[16] <= 6'h10;
            led_addr[17] <= 6'h11;
            led_addr[18] <= 6'h12;
            led_addr[19] <= 6'h13;
            led_addr[20] <= 6'h14;
            led_addr[21] <= 6'h15;
            led_addr[22] <= 6'h16;
            led_addr[23] <= 6'h17;
            led_addr[24] <= 6'h1F;
            led_addr[25] <= 6'h1E;
            led_addr[26] <= 6'h1D;
            led_addr[27] <= 6'h1C;
            led_addr[28] <= 6'h1B;
            led_addr[29] <= 6'h1A;
            led_addr[30] <= 6'h19;
            led_addr[31] <= 6'h18;
            led_addr[32] <= 6'h20;
            led_addr[33] <= 6'h21;
            led_addr[34] <= 6'h22;
            led_addr[35] <= 6'h23;
            led_addr[36] <= 6'h24;
            led_addr[37] <= 6'h25;
            led_addr[38] <= 6'h26;
            led_addr[39] <= 6'h27;
            led_addr[40] <= 6'h2F;
            led_addr[41] <= 6'h2E;
            led_addr[42] <= 6'h2D;
            led_addr[43] <= 6'h2C;
            led_addr[44] <= 6'h2B;
            led_addr[45] <= 6'h2A;
            led_addr[46] <= 6'h29;
            led_addr[47] <= 6'h28;
            led_addr[48] <= 6'h30;
            led_addr[49] <= 6'h31;
            led_addr[50] <= 6'h32;
            led_addr[51] <= 6'h33;
            led_addr[52] <= 6'h34;
            led_addr[53] <= 6'h35;
            led_addr[54] <= 6'h36;
            led_addr[55] <= 6'h37;
            led_addr[56] <= 6'h3F;
            led_addr[57] <= 6'h3E;
            led_addr[58] <= 6'h3D;
            led_addr[59] <= 6'h3C;
            led_addr[60] <= 6'h3B;
            led_addr[61] <= 6'h3A;
            led_addr[62] <= 6'h39;
            led_addr[63] <= 6'h38;
        `else
            led_addr[0] <= 6'h00;
            led_addr[1] <= 6'h01;
            led_addr[2] <= 6'h02;
            led_addr[3] <= 6'h03;
            led_addr[4] <= 6'h04;
            led_addr[5] <= 6'h05;
            led_addr[6] <= 6'h06;
            led_addr[7] <= 6'h07;
            led_addr[8] <= 6'h08;
            led_addr[9] <= 6'h09;
            led_addr[10] <= 6'h0A;
            led_addr[11] <= 6'h0B;
            led_addr[12] <= 6'h0C;
            led_addr[13] <= 6'h0D;
            led_addr[14] <= 6'h0E;
            led_addr[15] <= 6'h0F;
            led_addr[16] <= 6'h10;
            led_addr[17] <= 6'h11;
            led_addr[18] <= 6'h12;
            led_addr[19] <= 6'h13;
            led_addr[20] <= 6'h14;
            led_addr[21] <= 6'h15;
            led_addr[22] <= 6'h16;
            led_addr[23] <= 6'h17;
            led_addr[24] <= 6'h18;
            led_addr[25] <= 6'h19;
            led_addr[26] <= 6'h1A;
            led_addr[27] <= 6'h1B;
            led_addr[28] <= 6'h1C;
            led_addr[29] <= 6'h1D;
            led_addr[30] <= 6'h1E;
            led_addr[31] <= 6'h1F;
            led_addr[32] <= 6'h20;
            led_addr[33] <= 6'h21;
            led_addr[34] <= 6'h22;
            led_addr[35] <= 6'h23;
            led_addr[36] <= 6'h24;
            led_addr[37] <= 6'h25;
            led_addr[38] <= 6'h26;
            led_addr[39] <= 6'h27;
            led_addr[40] <= 6'h28;
            led_addr[41] <= 6'h29;
            led_addr[42] <= 6'h2A;
            led_addr[43] <= 6'h2B;
            led_addr[44] <= 6'h2C;
            led_addr[45] <= 6'h2D;
            led_addr[46] <= 6'h2E;
            led_addr[47] <= 6'h2F;
            led_addr[48] <= 6'h30;
            led_addr[49] <= 6'h31;
            led_addr[50] <= 6'h32;
            led_addr[51] <= 6'h33;
            led_addr[52] <= 6'h34;
            led_addr[53] <= 6'h35;
            led_addr[54] <= 6'h36;
            led_addr[55] <= 6'h37;
            led_addr[56] <= 6'h38;
            led_addr[57] <= 6'h39;
            led_addr[58] <= 6'h3A;
            led_addr[59] <= 6'h3B;
            led_addr[60] <= 6'h3C;
            led_addr[61] <= 6'h3D;
            led_addr[62] <= 6'h3E;
            led_addr[63] <= 6'h3F;
        `endif
    end else begin
        if (en_in) begin
            addr_out <= led_addr[idx_in];
        end else begin
            addr_out <= 6'h00;
        end
    end
end

endmodule
