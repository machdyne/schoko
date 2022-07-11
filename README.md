# Schoko Computer

Schoko is an FPGA computer designed by Lone Dynamics Corporation.

![Schoko Computer](https://github.com/machdyne/schoko/blob/dfc850e8b4c5a64a58aa2cf89866d35570c1b230/schoko.png)

This repo contains schematics, pinouts and example gateware.

Find more information on the [Schoko product page](https://machdyne.com/product/schoko-computer/).

## Programming Schoko

Schoko has a JTAG interface and ships with a [DFU bootloader](https://github.com/machdyne/tinydfu-bootloader) that allows the flash MMOD to be programmed over the USB-C port.

The first 1MB of the flash MMOD is reserved for the bootloader, the next 3MB are reserved for user gateware and the remaining space is available for user data.

### DFU

The DFU bootloader is available for 5 seconds after power-on, issuing a DFU command during this period will stop the boot process until the DFU device is detached. If no command is received the boot process will continue and the user gateware will be loaded.

Update the user gateware on the flash MMOD:

```
dfu-util -a 0 -D image.bit
```

Detach the DFU device and continue the boot process:

```
dfu-util -e
```

It is possible to update the bootloader itself using DFU but you shouldn't attempt this unless you have a JTAG programmer (or another method to program the MMOD) available, in case you need to restore the bootloader.

### JTAG

These examples assume you're using a "USB Blaster" JTAG cable, see the header pinout below.

Program the configuration SRAM:

```
openFPGALoader -c usb-blaster image.bit
```

Program the flash MMOD:

```
openFPGALoader -f -c usb-blaster bootloader.bit
```

## Blinky 

Building the blinky example requires [Yosys](https://github.com/YosysHQ/yosys), [nextpnr-ecp5](https://github.com/YosysHQ/nextpnr) and [Project Trellis](https://github.com/YosysHQ/prjtrellis).

Assuming they are installed, you can simply type `make` to build the gateware, which will be written to output/blinky.bin. You can then use [openFPGALoader](https://github.com/trabucayre/openFPGALoader) or dfu-util to write the gateware to the device.

## Linux

Copy the files from the images/v1\_hdmi directory to the root directory of a FAT-formated SD card.

Schoko ships with LiteX gateware on the user gateware section of the MMOD that is compatible with these images. If you plug a USB-UART into PMODA you should be able to interact with LiteX.

Detailed instructions for building custom LiteX gateware and Linux will be added here soon.

Note: It should be possible to store the Linux images on the MMOD itself and boot Linux without any SD card but this is not yet supported.

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
