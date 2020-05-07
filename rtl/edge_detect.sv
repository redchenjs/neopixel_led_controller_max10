/*
 * edge_detect.sv
 *
 *  Created on: 2020-04-09 17:46
 *      Author: Jack Chen <redchenjs@live.com>
 */

module edge_detect(
    input logic clk_in,
    input logic rst_n_in,

    input logic data_in,

    output logic pos_edge_out,
    output logic neg_edge_out,
    output logic both_edge_out
);

logic data_a, data_b;

assign pos_edge_out = data_a & ~data_b;
assign neg_edge_out = ~data_a & data_b;
assign both_edge_out = data_a ^ data_b;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        data_a <= 1'b0;
        data_b <= 1'b0;
    end else begin
        data_a <= data_in;
        data_b <= data_a;
    end
end

endmodule
