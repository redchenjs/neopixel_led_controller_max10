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

    input logic byte_rdy_in,
    input logic [7:0] byte_data_in,

    output logic frame_rdy_out,

    output logic [8:0] wr_en_out,
    output logic [5:0] wr_addr_out,
    output logic [3:0] byte_en_out
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
wire layer_next = addr_done & color_done & ~layer_done;
wire write_done = addr_done & color_done & layer_done;

assign wr_en_out[8] = addr_en[1] & byte_rdy_in;
assign wr_en_out[7] = layer_en[7] & byte_rdy_in;
assign wr_en_out[6] = layer_en[6] & byte_rdy_in;
assign wr_en_out[5] = layer_en[5] & byte_rdy_in;
assign wr_en_out[4] = layer_en[4] & byte_rdy_in;
assign wr_en_out[3] = layer_en[3] & byte_rdy_in;
assign wr_en_out[2] = layer_en[2] & byte_rdy_in;
assign wr_en_out[1] = layer_en[1] & byte_rdy_in;
assign wr_en_out[0] = layer_en[0] & byte_rdy_in;

assign byte_en_out = {addr_en[0], color_en};

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
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
                        layer_en <= 8'h00;
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
                layer_en <= (~addr_wr & layer_next) ? {layer_en[0], layer_en[7:1]} : layer_en;

                wr_addr_out <= wr_addr_out + (addr_wr | color_done);
            end
        endcase

        frame_rdy_out <= byte_rdy_in & dc_in & ~addr_wr & write_done;
    end
end

endmodule
