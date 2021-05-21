derive_clock_uncertainty
derive_pll_clocks -create_base_clocks

set_false_path -from [get_ports {rst_n_i}]

set_false_path -from [get_ports {dc_i}]
set_false_path -from [get_ports {spi_sclk_i}]
set_false_path -from [get_ports {spi_mosi_i}]
set_false_path -from [get_ports {spi_cs_n_i}]

set_false_path -to [get_ports {spi_miso_o}]

# FPS Counter
set_false_path -to [get_ports {segment_led_1_o[*]}]
set_false_path -to [get_ports {segment_led_2_o[*]}]

set_false_path -to [get_ports {neopixel_code_o[*]}]
