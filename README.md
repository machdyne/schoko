# Schoko Computer

Schoko is an FPGA computer designed by Lone Dynamics Corporation.

This repo contains schematics, pinouts and example gateware.

Find more information on the [Schoko product page](https://machdyne.com/product/schoko-computer/).

## Blinky 

Building the blinky example requires [Yosys](https://github.com/YosysHQ/yosys), [nextpnr-ecp5](https://github.com/YosysHQ/nextpnr) and [Project Trellis](https://github.com/YosysHQ/prjtrellis).

Assuming they are installed, you can simply type `make` to build the gateware, which will be written to output/blinky.bin. You can then use [openFPGALoader](https://github.com/trabucayre/openFPGALoader) to write the gateware to the device.

## Linux

Detailed instructions for running Linux on Schoko will be added here soon.

## JTAG Header

The JTAG header can be used to program the FPGA SRAM as well as the MMOD flash memory. 

```
1 2
3 4
5 6
```

| Pin | Signal |
| --- | ------ |
| 1 | TCK |
| 2 | TDI |
| 3 | TDO |
| 4 | TMS |
| 5 | 3V3 |
| 6 | GND |
