/*
 * test_channel_out.sv
 *
 *  Created on: 2020-07-08 21:15
 *      Author: Jack Chen <redchenjs@live.com>
 */

`timescale 1ns / 1ps

module test_channel_out;

logic clk_i;
logic rst_n_i;

logic [7:0] reg_t0h_time_i;
logic [8:0] reg_t0s_time_i;
logic [7:0] reg_t1h_time_i;
logic [8:0] reg_t1s_time_i;

logic       ram_wr_en_i;
logic       ram_wr_done_i;
logic [7:0] ram_wr_addr_i;
logic [7:0] ram_wr_data_i;
logic [3:0] ram_wr_byte_en_i;

logic bit_code_o;

channel_out test_channel_out(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),

    .reg_t0h_time_i(reg_t0h_time_i),
    .reg_t0s_time_i(reg_t0s_time_i),
    .reg_t1h_time_i(reg_t1h_time_i),
    .reg_t1s_time_i(reg_t1s_time_i),

    .ram_wr_en_i(ram_wr_en_i),
    .ram_wr_done_i(ram_wr_done_i),
    .ram_wr_addr_i(ram_wr_addr_i),
    .ram_wr_data_i(ram_wr_data_i),
    .ram_wr_byte_en_i(ram_wr_byte_en_i),

    .bit_code_o(bit_code_o)
);

initial begin
    clk_i   <= 1'b1;
    rst_n_i <= 1'b0;

    reg_t0h_time_i <= 8'h00;
    reg_t0s_time_i <= 9'h001;
    reg_t1h_time_i <= 8'h01;
    reg_t1s_time_i <= 9'h001;

    ram_wr_en_i   <= 1'b0;
    ram_wr_done_i <= 1'b0;
    ram_wr_addr_i <= 8'h00;
    ram_wr_data_i <= 8'h00;
    ram_wr_byte_en_i <= 4'b0000;

    #2 rst_n_i <= 1'b1;
end

always begin
    #2.5 clk_i <= ~clk_i;
end

always begin
    // ADDR 0
    #11 ram_wr_addr_i <= 8'h00;
        ram_wr_data_i <= 8'h01;
        ram_wr_byte_en_i <= 4'b1000;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    #10 ram_wr_data_i <= 8'h00;
        ram_wr_byte_en_i <= 4'b0111;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    // ADDR 1
    #10 ram_wr_addr_i <= 8'h01;
        ram_wr_data_i <= 8'h02;
        ram_wr_byte_en_i <= 4'b1000;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    #10 ram_wr_data_i <= 8'haa;
        ram_wr_byte_en_i <= 4'b0111;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    // ADDR 2
    #10 ram_wr_addr_i <= 8'h02;
        ram_wr_data_i <= 8'h03;
        ram_wr_byte_en_i <= 4'b1000;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    #10 ram_wr_data_i <= 8'hcc;
        ram_wr_byte_en_i <= 4'b0111;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    // ADDR 3
    #10 ram_wr_addr_i <= 8'h03;
        ram_wr_data_i <= 8'h00;
        ram_wr_byte_en_i <= 4'b1000;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    #10 ram_wr_data_i <= 8'hff;
        ram_wr_byte_en_i <= 4'b0111;
        ram_wr_en_i <= 1'b1;
    #5  ram_wr_en_i <= 1'b0;

    #10 ram_wr_done_i <= 1'b1;
    #5  ram_wr_done_i <= 1'b0;

    for (integer i = 0; i < 65536; i++) begin
        #5 ram_wr_done_i <= 1'b1;
        #5 ram_wr_done_i <= 1'b0;
    end

    for (integer i = 0; i < 1024; i++) begin
        #5 ram_wr_done_i <= 1'b0;
    end

    #75 rst_n_i <= 1'b0;
    #25 $stop;
end

endmodule
