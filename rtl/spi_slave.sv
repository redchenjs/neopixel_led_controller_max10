/*
 * spi_slave.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module spi_slave(
    input logic clk_i,
    input logic rst_n_i,

    input logic spi_sclk_i,
    input logic spi_mosi_i,
    input logic spi_cs_n_i,

    output logic       byte_vld_o,
    output logic [7:0] byte_data_o
);

logic spi_cs;
logic spi_sclk;
logic spi_mosi;
logic spi_rst_n;

logic [2:0] bit_sel;

logic       byte_vld;
logic [7:0] byte_data;

assign byte_vld_o  = byte_vld;
assign byte_data_o = byte_data;

rst_sync spi_rst_n_sync(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i & ~spi_cs_n_i),
    .rst_n_o(spi_rst_n)
);

edge_detect spi_sclk_edge(
   .clk_i(clk_i),
   .rst_n_i(spi_rst_n),
   .data_i(spi_sclk_i),
   .pos_edge_o(spi_sclk)
);

always_ff @(posedge clk_i or negedge spi_rst_n)
begin
    if (!spi_rst_n) begin
        spi_mosi <= 1'b0;

        bit_sel <= 3'h0;

        byte_vld  <= 1'b0;
        byte_data <= 8'h00;
    end else begin
        spi_mosi <= spi_mosi_i;

        bit_sel <= bit_sel + spi_sclk;

        byte_vld  <= spi_sclk & (bit_sel == 3'd7);
        byte_data <= spi_sclk ? {byte_data[6:0], spi_mosi} : byte_data;
    end
end

endmodule
