derive_clock_uncertainty
derive_pll_clocks -create_base_clocks

set_false_path -from [get_ports {rst_n_in}]

set_false_path -from [get_ports {dc_in}]
set_false_path -from [get_ports {spi_sclk_in}]
set_false_path -from [get_ports {spi_mosi_in}]
set_false_path -from [get_ports {spi_cs_n_in}]

set_false_path -to [get_ports {ws281x_code_out[*]}]

# FPS Counter
set_false_path -to [get_ports {water_led_out[*]}]
set_false_path -to [get_ports {segment_led_1_out[*]}]
set_false_path -to [get_ports {segment_led_2_out[*]}]
