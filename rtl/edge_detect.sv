/*
 * edge_detect.sv
 *
 *  Created on: 2020-04-09 17:46
 *      Author: Jack Chen <redchenjs@live.com>
 */

module edge_detect(
    input logic clk_i,
    input logic rst_n_i,

    input logic data_i,

    output logic pos_edge_o,
    output logic neg_edge_o,
    output logic both_edge_o
);

logic data_a, data_b;

assign pos_edge_o  = ~data_b & data_a;
assign neg_edge_o  = ~data_a & data_b;
assign both_edge_o =  data_a ^ data_b;

always_ff @(posedge clk_i or negedge rst_n_i)
begin
    if (!rst_n_i) begin
        data_a <= 1'b0;
        data_b <= 1'b0;
    end else begin
        data_a <= data_i;
        data_b <= data_a;
    end
end

endmodule
