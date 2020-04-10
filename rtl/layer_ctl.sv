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
    output logic [5:0] wr_addr_out,
    output logic [3:0] byte_en_out,
    output logic [7:0] layer_en_out
);

parameter [7:0] CUBE0414_ADDR_WR = 8'hcc;
parameter [7:0] CUBE0414_DATA_WR = 8'hda;

logic addr_en;
logic [2:0] color_en;
logic [7:0] layer_en;

assign byte_en_out = {addr_en, color_en};
assign layer_en_out = layer_en & {byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in};

logic frame_rdy;

edge2en frame_rdy_edge(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),

    .edge_in(frame_rdy),

    .rising_out(frame_rdy_out)
);

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        wr_addr_out <= 6'h00;

        frame_rdy <= 1'b0;

        addr_en <= 1'b0;
        color_en <= 3'b000;

        layer_en <= 8'h00;
    end else begin
        if (byte_rdy_in) begin
            if (!dc_in) begin   // Command
                wr_addr_out <= 6'h00;

                frame_rdy <= 1'b0;

                case (byte_data_in)
                    CUBE0414_ADDR_WR: begin    // Write RAM Addr
                        addr_en <= 1'b1;
                        color_en <= 3'b000;

                        layer_en <= 8'hff;
                    end
                    CUBE0414_DATA_WR: begin    // Write RAM Data
                        addr_en <= 1'b0;
                        color_en <= 3'b100;

                        layer_en <= 8'h80;
                    end
                    default: begin
                        addr_en <= 1'b0;
                        color_en <= 3'b000;

                        layer_en <= 8'h00;
                    end
                endcase
            end else begin  // Data
                if (addr_en) begin  // Write RAM Addr
                    if (wr_addr_out == 6'd63) begin
                        wr_addr_out <= 6'h00;

                        layer_en <= 8'h00;
                    end else begin
                        wr_addr_out <= wr_addr_out + 1'b1;
                    end
                end else begin      // Write RAM Data
                    if (color_en[0]) begin
                        if (wr_addr_out == 6'd63) begin
                            wr_addr_out <= 6'h00;

                            if (layer_en[0]) begin
                                layer_en <= 8'h00;

                                frame_rdy <= 1'b1;
                            end else begin
                                layer_en <= {layer_en[0], layer_en[7:1]};
                            end
                        end else begin
                            wr_addr_out <= wr_addr_out + 1'b1;
                        end
                    end

                    color_en <= {color_en[0], color_en[2:1]};
                end
            end
        end
    end
end

endmodule
