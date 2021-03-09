/*
 * spi_slave.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module spi_slave(
    input logic clk_i,
    input logic rst_n_i,

    input logic       spi_sclk_i,
    input logic       spi_mosi_i,
    input logic       spi_cs_n_i,
    input logic [7:0] spi_byte_data_i,

    output logic       spi_miso_o,
    output logic       spi_byte_vld_o,
    output logic [7:0] spi_byte_data_o
);

logic spi_cs;
logic spi_rst_n;
logic spi_sclk_p;
logic spi_sclk_n;

logic [2:0] bit_sel;
logic       bit_mosi;

logic       byte_vld;
logic [7:0] byte_mosi;
logic [7:0] byte_miso;

assign spi_miso_o      = byte_miso[7];
assign spi_byte_vld_o  = byte_vld;
assign spi_byte_data_o = byte_mosi;

rst_syn spi_rst_n_syn(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i & ~spi_cs_n_i),
    .rst_n_o(spi_rst_n)
);

edge2en spi_sclk_en(
    .clk_i(clk_i),
    .rst_n_i(spi_rst_n),
    .data_i(spi_sclk_i),
    .pos_edge_o(spi_sclk_p),
    .neg_edge_o(spi_sclk_n)
);

always_ff @(posedge clk_i or negedge spi_rst_n)
begin
    if (!spi_rst_n) begin
        bit_sel  <= 3'h0;
        bit_mosi <= 1'b0;

        byte_vld  <= 1'b0;
        byte_mosi <= 8'h00;
        byte_miso <= 8'h00;
    end else begin
        bit_sel  <= spi_sclk_p + bit_sel;
        bit_mosi <= spi_mosi_i;

        byte_vld  <= spi_sclk_p & (bit_sel == 3'h7);
        byte_mosi <= spi_sclk_p ? {byte_mosi[6:0], bit_mosi} : byte_mosi;
        byte_miso <= spi_sclk_n ? ((bit_sel == 3'h0) ? spi_byte_data_i : {byte_miso[6:0], 1'b0}) : byte_miso;
    end
end

endmodule
