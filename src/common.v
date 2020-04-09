/*
 * common.v
 *
 *  Created on: 2020-04-09 17:46
 *      Author: Jack Chen <redchenjs@live.com>
 */

module edge2en(
    input wire clk_in,
    input wire rst_n_in,

    input wire edge_in,

    output wire rising_out,
    output wire falling_out
);

reg edge_cur;
reg edge_pre;

assign rising_out = edge_cur & ~edge_pre;
assign falling_out = ~edge_cur & edge_pre;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        edge_cur <= 1'b0;
        edge_pre <= 1'b0;
    end else begin
        edge_cur <= edge_in;
        edge_pre <= edge_cur;
    end
end

endmodule
