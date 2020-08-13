WS281X Cube Controller
======================

WS281X Cube Controller based on MAX10 FPGA.

## Main Features

* 4-wire SPI interface
* High refresh rate (up to 500fps@8x8x8)
* 8 parallel output data lines (64 LEDs per line)
* Configurable waveform generator (T0H, T0L, T1H, T1L)
* Configurable LED serial connection sequence (address linked list)

## Pinout

| Input Port | FPGA Pin |    Output Port   | FPGA Pin |
| ---------: | :------- | :--------------: | :------: |
|      clk_i | PIN_J5   | ws281x_code_o[7] |  PIN_R5  |
|    rst_n_i | PIN_R9   | ws281x_code_o[6] |  PIN_L7  |
|       dc_i | PIN_P15  | ws281x_code_o[5] |  PIN_P4  |
| spi_sclk_i | PIN_R14  | ws281x_code_o[4] |  PIN_L6  |
| spi_mosi_i | PIN_P12  | ws281x_code_o[3] |  PIN_R3  |
| spi_cs_n_i | PIN_R11  | ws281x_code_o[2] |  PIN_M5  |
|          - |          | ws281x_code_o[1] |  PIN_P3  |
|          - |          | ws281x_code_o[0] |  PIN_M4  |

* SPI slave mode: MODE 0, CPOL=0, CPHA=0, MSB first

## Commands

### CONF_WR

| Inst / Para | D/C | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | --: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   CONF_WR   |   0 |  0 |  0 |  1 |  0 |  1 |  0 |  1 |  0 | 2Ah |
|  1st Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  2nd Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  3rd Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  4th Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: T0H time, range: 1-255, unit: 10 ns
* 2nd Param: T0L time, range: 1-255, unit: 10 ns
* 3rd Param: T1H time, range: 1-255, unit: 10 ns
* 4th Param: T1L time, range: 1-255, unit: 10 ns

Limits:

* T0H + T0L <= 257 = 2570 ns = 2.57 us
* T1H + T1L <= 257 = 2570 ns = 2.57 us

### ADDR_WR

| Inst / Para | D/C | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | --: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   ADDR_WR   |   0 |  0 |  0 |  1 |  0 |  1 |  0 |  1 |  1 | 2Bh |
|  1st Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|     ...     |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  Nth Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: 2nd LED address, range: 0-63
* 2nd Param: 3rd LED address, range: 0-63
* 3rd Param: 4th LED address, range: 0-63
* ...
* Nth Param: 1st LED address, range: 0-63

* N = 64

* These configurations will be applied to all 8 layers

### DATA_WR

| Inst / Para | D/C | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | --: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   DATA_WR   |   0 |  0 |  0 |  1 |  0 |  1 |  1 |  0 |  0 | 2Ch |
|  1st Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|     ...     |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  Nth Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: 1st LED color byte 2, range: 0-255
* 2nd Param: 1st LED color byte 1, range: 0-255
* 3rd Param: 1st LED color byte 0, range: 0-255
* 4th Param: 2nd LED color byte 2, range: 0-255
* 5th Param: 2nd LED color byte 1, range: 0-255
* 6th Param: 2nd LED color byte 0, range: 0-255
* ...
* Nth Param: ...

* N = 8 x 8 x 8 x 3 = 1536

* Layer data order: layer 7 first (layer 7 - layer 0)
* Color byte order: high byte first (byte 2 - byte 0)

## Preparing

### Obtain the source

```
git clone https://github.com/redchenjs/ws281x_cube_controller_max10.git
```

### Update an existing repository

```
git pull
```

## Building

* Quartus Prime 20.1.0 Lite Edition

## Music Light Cube

<img src="docs/cube0414.png">

## Videos Links

* [音乐全彩光立方演示](https://www.bilibili.com/video/av25188707) ([YouTube](https://www.youtube.com/watch?v=F8nfA_mEhPg))
* [音乐全彩光立方配套微信小程序](https://www.bilibili.com/video/av83055233) ([YouTube](https://www.youtube.com/watch?v=HlruQqkIGtc))
