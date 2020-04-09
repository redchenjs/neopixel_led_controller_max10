derive_clock_uncertainty
derive_pll_clocks -create_base_clocks

create_clock -name {spi_sclk_in} -period 5.000 [get_ports {spi_sclk_in}]
