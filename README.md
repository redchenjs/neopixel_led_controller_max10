NeoPixel LED Controller
=======================

NeoPixel LED Controller based on MAX10 FPGA.

## Main Features

* 4-wire SPI interface (SCLK, MOSI, MISO, CS)
* High refresh rate (500fps@8x8x8, 125fps@16x16x16)
* 16 parallel output channels (up to 256 LEDs per channel)
* Each output channel has a programmable circular linked list
* Each output channel has a programmable waveform generator (T0H, T0L, T1H, T1L)

## Pinout

| Control I/O | FPGA Pin |      Data I/O      | FPGA Pin |      Data I/O       | FPGA Pin |
| ----------: | :------- | :----------------: | :------: | :-----------------: | :------: |
|       clk_i | PIN_J5   | neopixel_code_o[7] |  PIN_R5  | neopixel_code_o[15] |  PIN_C8  |
|     rst_n_i | PIN_P15  | neopixel_code_o[6] |  PIN_L7  | neopixel_code_o[14] |  PIN_B7  |
|        dc_i | PIN_R14  | neopixel_code_o[5] |  PIN_P4  | neopixel_code_o[13] |  PIN_D7  |
|  spi_sclk_i | PIN_P12  | neopixel_code_o[4] |  PIN_L6  | neopixel_code_o[12] |  PIN_E7  |
|  spi_mosi_i | PIN_R11  | neopixel_code_o[3] |  PIN_R3  | neopixel_code_o[11] |  PIN_B6  |
|  spi_cs_n_i | PIN_R9   | neopixel_code_o[2] |  PIN_M5  | neopixel_code_o[10] |  PIN_A7  |
|  spi_miso_o | PIN_P9   | neopixel_code_o[1] |  PIN_P3  | neopixel_code_o[9]  |  PIN_A5  |
|           - |          | neopixel_code_o[0] |  PIN_M4  | neopixel_code_o[8]  |  PIN_B4  |

* SPI slave mode: F_MAX=20MHz, CPOL=0, CPHA=0, MSB first

## Commands

### CONF_WR

| Inst / Para | D/C | R/W | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | :-: | :-: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   CONF_WR   |  0  |  W  |  0 |  0 |  1 |  0 |  1 |  0 |  1 |  0 | 2Ah |
|  1st Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  2nd Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  3rd Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  4th Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  5th Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  6th Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: T0H time (10 ns), range: 0 - 255
* 2nd Param: T0L time (10 ns), range: 0 - 255
* 3rd Param: T1H time (10 ns), range: 0 - 255
* 4th Param: T1L time (10 ns), range: 0 - 255
* 5th Param: Channel length, range: 0 - 255
* 6th Param: Channel count, range: 0 - 15

### ADDR_WR

| Inst / Para | D/C | R/W | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | :-: | :-: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   ADDR_WR   |  0  |  W  |  0 |  0 |  1 |  0 |  1 |  0 |  1 |  1 | 2Bh |
|  1st Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|     ...     |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  Nth Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: Channel 0, the next pointer of the 1st color data, range: 0 - 255
* 2nd Param: Channel 0, the next pointer of the 2nd color data, range: 0 - 255
* ...
* Nth Param: ...

* N_MAX = 256 x 16 = 4096

### DATA_WR

| Inst / Para | D/C | R/W | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | :-: | :-: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   DATA_WR   |  0  |  W  |  0 |  0 |  1 |  0 |  1 |  1 |  0 |  0 | 2Ch |
|  1st Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|     ...     |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  Nth Param  |  1  |  W  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: Channel 0, the 1st color data, byte 2, range: 0 - 255
* 2nd Param: Channel 0, the 1st color data, byte 1, range: 0 - 255
* 3rd Param: Channel 0, the 1st color data, byte 0, range: 0 - 255
* 4th Param: Channel 0, the 2nd color data, byte 2, range: 0 - 255
* ...
* Nth Param: ...

* N_MAX = 256 x 16 x 3 = 12288

### INFO_RD

| Inst / Para | D/C | R/W | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | :-: | :-: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   INFO_RD   |  0  |  W  |  0 |  0 |  1 |  1 |  1 |  0 |  1 |  0 | 3Ah |
|  1st Data   |  1  |  R  |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 | 00h |
|  2nd Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  3rd Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  4th Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  5th Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  6th Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  7th Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  7th Data   |  1  |  R  | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Data: Dummy byte, 0x00
* 2nd Data: RTL revision, major: {D7..D4}, minor: {D3..D0}
* 3rd Data: T0H time (10 ns), range: 0 - 255
* 4th Data: T0L time (10 ns), range: 0 - 255
* 5th Data: T1H time (10 ns), range: 0 - 255
* 6th Data: T1L time (10 ns), range: 0 - 255
* 7th Data: Channel length, range: 0 - 255
* 8th Data: Channel count, range: 0 - 15

## Preparing

### Obtain the source

```
git clone https://github.com/redchenjs/neopixel_led_controller_max10.git
```

### Update an existing repository

```
git pull
```

## Building

* Quartus Prime 21.1.0 Lite Edition

## Music Light Cube

<img src="docs/cube0414.png">

## Videos Links

* [音乐全彩光立方演示](https://www.bilibili.com/video/av25188707) ([YouTube](https://www.youtube.com/watch?v=F8nfA_mEhPg))
* [音乐全彩光立方配套微信小程序](https://www.bilibili.com/video/av83055233) ([YouTube](https://www.youtube.com/watch?v=HlruQqkIGtc))
