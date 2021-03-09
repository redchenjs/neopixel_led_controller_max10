/*
 * sys_ctl.sv
 *
 *  Created on: 2020-05-07 09:58
 *      Author: Jack Chen <redchenjs@live.com>
 */

module sys_ctl(
    input logic clk_i,
    input logic rst_n_i,

    output logic sys_clk_o,
    output logic sys_rst_n_o
);

logic pll_100m;
logic pll_locked;

logic pll_rst_n;
logic sys_rst_n;

rst_syn pll_rst_n_syn(
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .rst_n_o(pll_rst_n)
);

pll pll(
    .areset(~pll_rst_n),
    .inclk0(clk_i),
    .c0(pll_100m),
    .locked(pll_locked)
);

rst_syn sys_rst_n_syn(
    .clk_i(pll_100m),
    .rst_n_i(rst_n_i & pll_locked),
    .rst_n_o(sys_rst_n)
);

globalclk global_clk(
    .inclk(pll_100m),
    .outclk(sys_clk_o)
);

globalclk global_rst_n(
    .inclk(sys_rst_n),
    .outclk(sys_rst_n_o)
);

endmodule
