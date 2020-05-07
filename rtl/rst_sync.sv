/*
 * rst_sync.sv
 *
 *  Created on: 2020-05-07 18:57
 *      Author: Jack Chen <redchenjs@live.com>
 */

module rst_sync(
    input logic clk_in,
    input logic rst_n_in,

    output logic rst_n_out
);

logic rst_n_a, rst_n_b;

assign rst_n_out = rst_n_b;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        rst_n_a <= 1'b0;
        rst_n_b <= 1'b0;
    end else begin
        rst_n_a <= 1'b1;
        rst_n_b <= rst_n_a;
    end
end

endmodule
