/*
 * spi_slave.sv
 *
 *  Created on: 2020-04-06 23:07
 *      Author: Jack Chen <redchenjs@live.com>
 */

module spi_slave(
    input logic clk_i,
    input logic rst_n_i,

    input logic [7:0] spi_byte_data_i,

    input logic spi_sclk_i,
    input logic spi_mosi_i,
    input logic spi_cs_n_i,

    output logic spi_miso_o,

    output logic       spi_byte_vld_o,
    output logic [7:0] spi_byte_data_o
);

logic spi_sclk;

logic [2:0] bit_sel;
logic       bit_mosi;

logic       byte_vld;
logic [1:0] byte_rdy;

logic [7:0] byte_mosi;
logic [7:0] byte_miso;

assign spi_miso_o      = byte_miso[7];
assign spi_byte_vld_o  = byte_vld;
assign spi_byte_data_o = byte_mosi;

edge2en spi_sclk_en(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .data_i(spi_sclk_i),
    .pos_edge_o(spi_sclk)
);

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        bit_sel  <= 3'h0;
        bit_mosi <= 1'b0;

        byte_vld <= 1'b0;
        byte_rdy <= 2'b00;

        byte_mosi <= 8'h00;
        byte_miso <= 8'h00;
    end else begin
        bit_sel  <= spi_cs_n_i ? 3'h0 : bit_sel + spi_sclk;
        bit_mosi <= spi_mosi_i;

        byte_vld <= spi_sclk & (bit_sel == 3'h7);
        byte_rdy <= {byte_rdy[0], byte_vld};

        byte_mosi <= spi_sclk ? {byte_mosi[6:0], bit_mosi} : byte_mosi;
        byte_miso <= byte_rdy[1] ? spi_byte_data_i : (spi_sclk ? {byte_miso[6:0], 1'b0} : byte_miso);
    end
end

endmodule
