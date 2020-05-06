WS2812 LED Controller
=====================

Music Light Cube WS2812 LED Controller based on MAX10 FPGA.

## Main Features

* 4-Wire SPI Interface
* High Refresh Rate (Up to 500fps@8x8x8)
* 8 Data Lines in Parallel (64 LEDs per line)
* Configurable Waveform Generator (T0H, T0L, T1H, T1L, RST)
* Configurable LED Serial Connection Sequence (Addr Linked List)

## Commands

### CONF_WR

| Inst / Para | D/C | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | --: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   CONF_WR   |   0 |  0 |  0 |  1 |  0 |  1 |  0 |  1 |  0 | 2Ah |
|  1st Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  2nd Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  3rd Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  4th Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  5th Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  6th Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* 1st Param: T0H Time, unit: 10 ns
* 2nd Param: T0L Time, unit: 10 ns
* 3rd Param: T1H Time, unit: 10 ns
* 4th Param: T1L Time, unit: 10 ns
* 5th Param: RST Time H, unit: 10 ns
* 6th Param: RST Time L, unit: 10 ns

Limits:

* T0H + T0L <= 255 = 2550 ns = 2.55 us
* T1H + T1L <= 255 = 2550 ns = 2.55 us
* RST <= 65535 = 655350 ns = 655.35 us

### ADDR_WR

| Inst / Para | D/C | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | --: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   ADDR_WR   |   0 |  0 |  0 |  1 |  0 |  1 |  0 |  1 |  1 | 2Bh |
|  1st Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|     ...     |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  Nth Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* N = 64, LED Addr Linked List (Same for 8 layers)

### DATA_WR

| Inst / Para | D/C | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 | HEX |
| :---------: | --: | -: | -: | -: | -: | -: | -: | -: | -: | --: |
|   DATA_WR   |   0 |  0 |  0 |  1 |  0 |  1 |  1 |  0 |  0 | 2Ch |
|  1st Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|     ...     |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |
|  Nth Param  |   1 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |     |

* N = 8 x 8 x 8 x 3 = 1536, LED Color Data (24-bit)

## Preparing

### Obtain the source

```
git clone https://github.com/redchenjs/ws2812_led_controller_max10.git
```

### Update an existing repository

```
git pull
```

## Building

* Quartus Prime 19.1.0 Lite Edition

## Music Light Cube

<img src="docs/cube0414.png">

## Videos Links

* [音乐全彩光立方演示](https://www.bilibili.com/video/av25188707) ([YouTube](https://www.youtube.com/watch?v=F8nfA_mEhPg))
* [音乐全彩光立方配套微信小程序](https://www.bilibili.com/video/av83055233) ([YouTube](https://www.youtube.com/watch?v=HlruQqkIGtc))
