/*
 * rst_sync.sv
 *
 *  Created on: 2020-05-07 18:57
 *      Author: Jack Chen <redchenjs@live.com>
 */

module rst_sync(
    input logic clk_in,
    input logic rst_n_in,

    output logic rst_sync_n_out
);

logic rst_sync_a;
logic rst_sync_b;

assign rst_sync_n_out = rst_sync_b;

always_ff @(posedge clk_in or negedge rst_n_in)
begin
    if (!rst_n_in) begin
        rst_sync_a <= 1'b0;
        rst_sync_b <= 1'b0;
    end else begin
        rst_sync_a <= 1'b1;
        rst_sync_b <= rst_sync_a;
    end
end

endmodule
