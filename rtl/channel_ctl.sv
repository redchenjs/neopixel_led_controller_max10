/*
 * channel_ctl.sv
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

module channel_ctl(
    input logic clk_i,
    input logic rst_n_i,

    input logic dc_i,

    input logic       spi_byte_vld_i,
    input logic [7:0] spi_byte_data_i,

    input logic [7:0] reg_chan_len_i,
    input logic [3:0] reg_chan_cnt_i,

    output logic [2:0] reg_rd_addr_o,

    output logic       reg_wr_en_o,
    output logic [2:0] reg_wr_addr_o,

    output logic [15:0] ram_wr_en_o,
    output logic        ram_wr_done_o,
    output logic  [7:0] ram_wr_addr_o,
    output logic  [3:0] ram_wr_byte_en_o
);

typedef enum logic [7:0] {
    CUBE0414_CONF_WR = 8'h2a,
    CUBE0414_ADDR_WR = 8'h2b,
    CUBE0414_DATA_WR = 8'h2c,
    CUBE0414_INFO_RD = 8'h3a
} cmd_t;

logic [2:0] rd_addr;
logic [7:0] wr_addr;

logic       addr_en;
logic [2:0] data_en;

logic        info_rd;
logic        conf_wr;
logic [15:0] data_wr;

wire addr_done = (wr_addr == reg_chan_len_i) & addr_en;
wire data_done = (wr_addr == reg_chan_len_i) & data_en[0];

genvar i;
generate
    for (i = 0; i < 16; i++) begin: ram_wr_en
        assign ram_wr_en_o[i] = spi_byte_vld_i & data_wr[i];
    end
endgenerate

assign reg_rd_addr_o = rd_addr;

assign reg_wr_en_o   = spi_byte_vld_i & conf_wr;
assign reg_wr_addr_o = wr_addr;

assign ram_wr_done_o = spi_byte_vld_i & data_wr[reg_chan_cnt_i] & data_done;
assign ram_wr_addr_o = wr_addr;

assign ram_wr_byte_en_o = {addr_en, data_en};

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        rd_addr <= 3'h0;
        wr_addr <= 8'h00;

        addr_en <= 1'b0;
        data_en <= 3'b000;

        info_rd <= 1'b0;
        conf_wr <= 1'b0;
        data_wr <= 16'h0000;
    end else begin
        if (spi_byte_vld_i) begin
            if (!dc_i) begin  // Command
                wr_addr <= 8'h00;

                case (spi_byte_data_i)
                    CUBE0414_CONF_WR: begin     // Write Reg Conf
                        rd_addr <= 3'h0;

                        addr_en <= 1'b0;
                        data_en <= 3'b000;

                        info_rd <= 1'b0;
                        conf_wr <= 1'b1;
                        data_wr <= 16'h0000;
                    end
                    CUBE0414_ADDR_WR: begin     // Write RAM Addr
                        rd_addr <= 3'h0;

                        addr_en <= 1'b1;
                        data_en <= 3'b000;

                        info_rd <= 1'b0;
                        conf_wr <= 1'b0;
                        data_wr <= 16'h0001;
                    end
                    CUBE0414_DATA_WR: begin     // Write RAM Data
                        rd_addr <= 3'h0;

                        addr_en <= 1'b0;
                        data_en <= 3'b100;

                        info_rd <= 1'b0;
                        conf_wr <= 1'b0;
                        data_wr <= 16'h0001;
                    end
                    CUBE0414_INFO_RD: begin     // Read Chip Info
                        rd_addr <= 3'h1;

                        addr_en <= 1'b0;
                        data_en <= 3'b000;

                        info_rd <= 1'b1;
                        conf_wr <= 1'b0;
                        data_wr <= 16'h0000;
                    end
                    default: begin
                        rd_addr <= 3'h0;

                        addr_en <= 1'b0;
                        data_en <= 3'b000;

                        info_rd <= 1'b0;
                        conf_wr <= 1'b0;
                        data_wr <= 16'h0000;
                    end
                endcase
            end else begin    // Data
                rd_addr <= rd_addr + info_rd;
                wr_addr <= (addr_done | data_done) ? 8'h00 : wr_addr + (conf_wr | addr_en | data_en[0]);

                addr_en <= addr_en & ~(addr_done & data_wr[reg_chan_cnt_i]);
                data_en <= {data_en[0], data_en[2:1]};

                info_rd <= info_rd;
                conf_wr <= conf_wr;
                data_wr <= data_wr << (addr_done | data_done);
            end
        end
    end
end

endmodule
