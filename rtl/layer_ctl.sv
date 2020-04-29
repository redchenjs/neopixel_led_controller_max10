/*
 * layer_ctl.sv
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_ctl(
    input logic clk_in,
    input logic rst_n_in,

    input logic dc_in,
    input logic spi_cs_n_in,

    input logic byte_rdy_in,
    input logic [7:0] byte_data_in,

    output logic frame_rdy_out,

    output logic [7:0] wr_en_out,
    output logic [5:0] wr_addr_out,
    output logic [4:0] byte_en_out
);

parameter [7:0] CUBE0414_CONF_WR = 8'h2a;
parameter [7:0] CUBE0414_ADDR_WR = 8'h2b;
parameter [7:0] CUBE0414_DATA_WR = 8'h2c;

logic [1:0] addr_en;
logic [2:0] color_en;
logic [7:0] layer_en;

wire addr_wr = addr_en[0] | addr_en[1];
wire addr_done = (wr_addr_out == 6'd63);
wire color_done = color_en[0];
wire layer_done = layer_en[0];
wire write_done = addr_done & color_done & layer_done;

assign wr_en_out = layer_en & {byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in};
assign byte_en_out = {addr_en, color_en};

logic spi_cs_n_f, spi_rst_n;

edge2en spi_cs_n_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),
    .edge_in(spi_cs_n_in),
    .falling_out(spi_cs_n_f)
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        spi_rst_n <= 1'b0;
    end else begin
        spi_rst_n <= ~frame_rdy_out & (spi_cs_n_f | spi_rst_n);
    end
end

always_ff @(posedge clk_in or negedge spi_rst_n)
begin
    if (!spi_rst_n) begin
        addr_en <= 2'b00;

        color_en <= 3'b000;
        layer_en <= 8'h00;

        wr_addr_out <= 6'h00;
        frame_rdy_out <= 1'b0;
    end else begin
        case ({byte_rdy_in, dc_in})
            2'b10: begin    // Command
                case (byte_data_in)
                    CUBE0414_CONF_WR: begin     // Write Reg Conf
                        addr_en <= 2'b10;

                        color_en <= 3'b000;
                        layer_en <= 8'hff;
                    end
                    CUBE0414_ADDR_WR: begin     // Write RAM Addr
                        addr_en <= 2'b01;

                        color_en <= 3'b000;
                        layer_en <= 8'hff;
                    end
                    CUBE0414_DATA_WR: begin     // Write RAM Data
                        addr_en <= 2'b00;

                        color_en <= 3'b100;
                        layer_en <= 8'h80;
                    end
                    default: begin
                        addr_en <= 2'b00;

                        color_en <= 3'b000;
                        layer_en <= 8'h00;
                    end
                endcase

                wr_addr_out <= 6'h00;
            end
            2'b11: begin    // Data
                addr_en <= ~addr_done ? addr_en : 2'b00;

                color_en <= ~addr_wr ? {color_en[0], color_en[2:1]} : color_en;
                layer_en <= ~addr_wr ? (addr_done & color_done & ~layer_done)
                                     ? {layer_en[0], layer_en[7:1]} : layer_en
                                     : layer_en;

                wr_addr_out <= wr_addr_out + (addr_wr | color_done);
            end
        endcase

        frame_rdy_out <= byte_rdy_in & dc_in & ~addr_wr & write_done;
    end
end

endmodule
