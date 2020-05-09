/*
 * layer_ctrl.sv
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_ctrl(
    input logic clk_in,
    input logic rst_n_in,

    input logic dc_in,

    input logic       byte_rdy_in,
    input logic [7:0] byte_data_in,

    output logic [8:0] wr_en_out,
    output logic       wr_done_out,
    output logic [5:0] wr_addr_out,
    output logic [3:0] wr_byte_en_out
);

parameter [7:0] CUBE0414_CONF_WR = 8'h2a;
parameter [7:0] CUBE0414_ADDR_WR = 8'h2b;
parameter [7:0] CUBE0414_DATA_WR = 8'h2c;

logic       conf_wr;
logic [7:0] code_wr;

logic       addr_en;
logic [2:0] data_en;

logic [5:0] wr_addr;

wire conf_done = (wr_addr == 6'd5);
wire code_done = code_wr[0];

wire addr_done = (wr_addr == 6'd63);
wire data_done = data_en[0];

wire layer_done = addr_done & data_done;
wire frame_done = code_done & layer_done;

assign wr_en_out[8] = byte_rdy_in & conf_wr;
assign wr_en_out[7] = byte_rdy_in & code_wr[7];
assign wr_en_out[6] = byte_rdy_in & code_wr[6];
assign wr_en_out[5] = byte_rdy_in & code_wr[5];
assign wr_en_out[4] = byte_rdy_in & code_wr[4];
assign wr_en_out[3] = byte_rdy_in & code_wr[3];
assign wr_en_out[2] = byte_rdy_in & code_wr[2];
assign wr_en_out[1] = byte_rdy_in & code_wr[1];
assign wr_en_out[0] = byte_rdy_in & code_wr[0];

assign wr_done_out = byte_rdy_in & frame_done;
assign wr_addr_out = wr_addr;

assign wr_byte_en_out = {addr_en, data_en};

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        conf_wr <= 1'b0;
        code_wr <= 8'h00;

        addr_en <= 1'b0;
        data_en <= 3'b000;

        wr_addr <= 6'h00;
    end else begin
        if (byte_rdy_in) begin
            if (!dc_in) begin   // Command
                case (byte_data_in)
                    CUBE0414_CONF_WR: begin     // Write Reg Conf
                        conf_wr <= 1'b1;
                        code_wr <= 8'h00;

                        addr_en <= 1'b0;
                        data_en <= 3'b000;
                    end
                    CUBE0414_ADDR_WR: begin     // Write RAM Addr
                        conf_wr <= 1'b0;
                        code_wr <= 8'hff;

                        addr_en <= 1'b1;
                        data_en <= 3'b000;
                    end
                    CUBE0414_DATA_WR: begin     // Write RAM Data
                        conf_wr <= 1'b0;
                        code_wr <= 8'h80;

                        addr_en <= 1'b0;
                        data_en <= 3'b100;
                    end
                    default: begin
                        conf_wr <= 1'b0;
                        code_wr <= 8'h00;

                        addr_en <= 1'b0;
                        data_en <= 3'b000;
                    end
                endcase

                wr_addr <= 6'h00;
            end else begin      // Data
                conf_wr <= conf_wr & ~conf_done;
                code_wr <= code_wr >> (~(conf_wr | addr_en) & layer_done);

                addr_en <= addr_en & ~addr_done;
                data_en <= {data_en[0], data_en[2:1]};

                wr_addr <= wr_addr + (conf_wr | addr_en | data_done);
            end
        end
    end
end

endmodule
