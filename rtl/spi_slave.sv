/*
 * spi_slave.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module spi_slave(
    input logic clk_in,
    input logic rst_n_in,

    input logic spi_sclk_in,
    input logic spi_mosi_in,
    input logic spi_cs_n_in,

    output logic       byte_rdy_out,
    output logic [7:0] byte_data_out
);

logic spi_cs;
logic spi_sclk;
logic spi_mosi;
logic spi_rst_n;

logic [2:0] bit_sel;

logic       byte_rdy;
logic [7:0] byte_data;

assign byte_rdy_out  = byte_rdy;
assign byte_data_out = byte_data;

rst_sync spi_rst_n_sync(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in & ~spi_cs_n_in),
    .rst_n_out(spi_rst_n)
);

edge_detect spi_sclk_edge(
   .clk_in(clk_in),
   .rst_n_in(spi_rst_n),
   .data_in(spi_sclk_in),
   .pos_edge_out(spi_sclk)
);

always_ff @(posedge clk_in or negedge spi_rst_n)
begin
    if (!spi_rst_n) begin
        spi_mosi <= 1'b0;

        bit_sel <= 3'h0;

        byte_rdy  <= 1'b0;
        byte_data <= 8'h00;
    end else begin
        spi_mosi <= spi_mosi_in;

        bit_sel <= bit_sel + spi_sclk;

        byte_rdy  <= spi_sclk & (bit_sel == 3'd7);
        byte_data <= spi_sclk ? {byte_data[6:0], spi_mosi} : byte_data;
    end
end

endmodule
