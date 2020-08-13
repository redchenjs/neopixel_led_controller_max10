/*
 * layer_ctrl.sv
 *
 *  Created on: 2020-04-06 23:08
 *      Author: Jack Chen <redchenjs@live.com>
 */

module layer_ctrl(
    input logic clk_i,
    input logic rst_n_i,

    input logic dc_i,

    input logic       byte_vld_i,
    input logic [7:0] byte_data_i,

    output logic [8:0] wr_en_o,
    output logic       wr_done_o,
    output logic [5:0] wr_addr_o,
    output logic [3:0] wr_byte_en_o
);

typedef enum logic [7:0] {
    CUBE0414_CONF_WR = 8'h2a,
    CUBE0414_ADDR_WR = 8'h2b,
    CUBE0414_DATA_WR = 8'h2c
} cmd_t;

logic       conf_wr;
logic [7:0] code_wr;

logic       addr_en;
logic [2:0] data_en;

logic [5:0] wr_addr;

wire conf_done = (wr_addr == 6'd3);
wire code_done = code_wr[0];

wire addr_done = (wr_addr == 6'd63);
wire data_done = data_en[0];

wire layer_done = addr_done & data_done;
wire frame_done = code_done & layer_done;

assign wr_en_o[8] = byte_vld_i & conf_wr;
assign wr_en_o[7] = byte_vld_i & code_wr[7];
assign wr_en_o[6] = byte_vld_i & code_wr[6];
assign wr_en_o[5] = byte_vld_i & code_wr[5];
assign wr_en_o[4] = byte_vld_i & code_wr[4];
assign wr_en_o[3] = byte_vld_i & code_wr[3];
assign wr_en_o[2] = byte_vld_i & code_wr[2];
assign wr_en_o[1] = byte_vld_i & code_wr[1];
assign wr_en_o[0] = byte_vld_i & code_wr[0];

assign wr_done_o = byte_vld_i & frame_done;
assign wr_addr_o = wr_addr;

assign wr_byte_en_o = {addr_en, data_en};

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        conf_wr <= 1'b0;
        code_wr <= 8'h00;

        addr_en <= 1'b0;
        data_en <= 3'b000;

        wr_addr <= 6'h00;
    end else begin
        if (byte_vld_i) begin
            if (!dc_i) begin  // Command
                case (byte_data_i)
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
            end else begin    // Data
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
