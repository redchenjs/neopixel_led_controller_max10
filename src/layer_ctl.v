/*
 * layer_ctl.v
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

`define CUBE0414_ADDR_WR 8'hcc
`define CUBE0414_DATA_WR 8'hda

module layer_ctl(
	input wire clk_in,
    input wire rst_n_in,
    
	input wire dc_in,
	input wire spi_rdy_in,
	input wire [7:0] spi_data_in,
    
    output wire data_rdy_out,
	output wire [5:0] data_idx_out,
	output wire [3:0] byte_sel_out,
    output wire [7:0] layer_sel_out
);

reg	addr_en;
reg	[2:0] byte_sel;
reg	[7:0] layer_sel;

assign byte_sel_out = {addr_en, byte_sel};
assign layer_sel_out = layer_sel & {spi_rdy_in, spi_rdy_in, spi_rdy_in, spi_rdy_in, spi_rdy_in, spi_rdy_in, spi_rdy_in, spi_rdy_in};

reg data_rdy;
reg [1:0] data_rdy_pul;

assign data_rdy_out = data_rdy_pul[0] & ~data_rdy_pul[1];   // Rising Edge Pulse

always @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        data_idx_out <= 6'b0;

        addr_en <= 1'b0;
        byte_sel <= 3'b000;
        layer_sel <= 8'h00;
    end else if (spi_rdy_in == 1'b1) begin
        case (dc_in)
        1'b0: begin // Command
            data_rdy <= 1'b0;
            data_idx_out <= 6'b0;

            case (spi_data_in)
                `CUBE0414_ADDR_WR: begin    // Write RAM Addr
                    addr_en <= 1'b1;
                    byte_sel <= 3'b000;
                    layer_sel <= 8'hff;
                end
                `CUBE0414_DATA_WR: begin    // Write RAM Data
                    addr_en <= 1'b0;
                    byte_sel <= 3'b100;
                    layer_sel <= 8'h01;
                end
            endcase
        end
        1'b1:   // Data
            if (addr_en == 1'b1) begin      // Write RAM Addr
                data_idx_out <= data_idx_out + 6'd1;
                
                if (data_idx_out == 6'd63) begin
                    data_idx_out <= 6'd0;
                end
            end else begin                 // Write RAM Data
                byte_sel <= {byte_sel[0], byte_sel[2:1]};

                if (byte_sel == 3'b001) begin
                    data_idx_out <= data_idx_out + 6'd1;
                end

                if (byte_sel == 3'b001 && data_idx_out == 6'd63) begin
                    if (layer_sel != 8'h80) begin
                        layer_sel <= {layer_sel[6:0], layer_sel[7]};
                    end else begin
                        data_rdy <= 1'b1;
                        layer_sel <= 8'h00;
                    end
                end
            end
        endcase
	end
end

always @(negedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        data_rdy_pul <= 2'b0;
    end else begin
        data_rdy_pul[0] <= data_rdy;
        data_rdy_pul[1] <= data_rdy_pul[0];
    end
end

endmodule
