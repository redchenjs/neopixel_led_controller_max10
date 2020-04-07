/*
 * layer_ctl.v
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_ctl(
    input wire clk_in,
    input wire rst_n_in,

    input wire dc_in,
    input wire byte_rdy_in,
    input wire [7:0] byte_data_in,

    output wire frame_rdy_out,
    output wire [5:0] word_idx_out,
    output wire [3:0] byte_sel_out,
    output wire [7:0] layer_sel_out
);

parameter [7:0] CUBE0414_ADDR_WR = 8'hcc;
parameter [7:0] CUBE0414_DATA_WR = 8'hda;

reg	addr_en;
reg	[2:0] byte_sel;
reg	[7:0] layer_sel;

assign byte_sel_out = {addr_en, byte_sel};
assign layer_sel_out = layer_sel & {byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in, byte_rdy_in};

reg frame_rdy;
reg [1:0] frame_rdy_pul;
assign frame_rdy_out = frame_rdy_pul[0] & ~frame_rdy_pul[1];   // Rising Edge Pulse

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        word_idx_out <= 6'h00;

        addr_en <= 1'b0;
        byte_sel <= 3'b000;
        layer_sel <= 8'h00;
    end else begin
        if (byte_rdy_in) begin
            if (!dc_in) begin   // Command
                frame_rdy <= 1'b0;
                word_idx_out <= 6'h00;

                case (byte_data_in)
                    CUBE0414_ADDR_WR: begin    // Write RAM Addr
                        addr_en <= 1'b1;
                        byte_sel <= 3'b000;
                        layer_sel <= 8'hff;
                    end
                    CUBE0414_DATA_WR: begin    // Write RAM Data
                        addr_en <= 1'b0;
                        byte_sel <= 3'b100;
                        layer_sel <= 8'h01;
                    end
                endcase
            end else begin  // Data
                if (addr_en) begin  // Write RAM Addr
                    word_idx_out <= word_idx_out + 1'b1;

                    if (word_idx_out == 6'd63) begin
                        layer_sel <= 8'h00;
                    end
                end else begin      // Write RAM Data
                    byte_sel <= {byte_sel[0], byte_sel[2:1]};

                    if (byte_sel[0]) begin
                        word_idx_out <= word_idx_out + 1'b1;

                        if (word_idx_out == 6'd63) begin
                            if (layer_sel[7]) begin
                                layer_sel <= 8'h00;

                                frame_rdy <= 1'b1;
                            end else begin
                                layer_sel <= {layer_sel[6:0], layer_sel[7]};
                            end
                        end
                    end
                end
            end
        end
    end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        frame_rdy_pul <= 2'b00;
    end else begin
        frame_rdy_pul[0] <= frame_rdy;
        frame_rdy_pul[1] <= frame_rdy_pul[0];
    end
end

endmodule
