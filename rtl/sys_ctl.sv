/*
 * sys_ctl.sv
 *
 *  Created on: 2020-05-07 09:58
 *      Author: Jack Chen <redchenjs@live.com>
 */

module sys_ctl(
    input logic clk_in,
    input logic rst_n_in,

    output logic sys_clk_out,
    output logic sys_rst_n_out
);

logic pll_200m;
logic pll_locked;

logic pll_rst_n;
logic sys_rst_n;

rst_sync pll_rst_n_sync(
    .clk_in(clk_in),
    .rst_n_in(rst_n_in),
    .rst_n_out(pll_rst_n)
);

pll pll(
    .areset(~pll_rst_n),
    .inclk0(clk_in),
    .c0(pll_200m),
    .locked(pll_locked)
);

rst_sync sys_rst_n_sync(
    .clk_in(pll_200m),
    .rst_n_in(rst_n_in & pll_locked),
    .rst_n_out(sys_rst_n)
);

globalclk global_clk(
    .inclk(pll_200m),
    .ena(1'b1),
    .outclk(sys_clk_out)
);

globalclk global_rst_n(
    .inclk(sys_rst_n),
    .ena(1'b1),
    .outclk(sys_rst_n_out)
);

endmodule
