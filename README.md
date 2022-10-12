# Schoko Computer

Schoko is an FPGA computer designed by Lone Dynamics Corporation.

![Schoko Computer](https://github.com/machdyne/schoko/blob/ec24b2a678daf4e97074303b68460d9f22f655af/schoko.png)

This repo contains schematics, pinouts, a 3D-printable case, example gateware and documentation.

Find more information on the [Schoko product page](https://machdyne.com/product/schoko-computer/).

## Programming Schoko

Schoko has a JTAG interface and ships with a [DFU bootloader](https://github.com/machdyne/tinydfu-bootloader) that allows the included flash [MMOD](https://machdyne.com/product/mmod) to be programmed over the USB-C port.

The first 1MB of the flash MMOD is reserved for the bootloader, the next 3MB are reserved for user gateware and the remaining space is available for user data.

### DFU

The DFU bootloader is available for 5 seconds after power-on, issuing a DFU command during this period will stop the boot process until the DFU device is detached. If no command is received the boot process will continue and the user gateware will be loaded.

Install [dfu-util](http://dfu-util.sourceforge.net) (Debian/Ubuntu):

```
$ sudo apt install dfu-util
```

Update the user gateware on the flash MMOD:

```
$ sudo dfu-util -a 0 -D image.bit
```

Detach the DFU device and continue the boot process:

```
$ sudo dfu-util -a 0 -e
```

It is possible to update the bootloader itself using DFU but you shouldn't attempt this unless you have a JTAG programmer (or another method to program the MMOD) available, in case you need to restore the bootloader.

### JTAG

These examples assume you're using a "USB Blaster" JTAG cable, see the header pinout below. You will need to have [openFPGALoader](https://github.com/trabucayre/openFPGALoader) installed.

Program the configuration SRAM:

```
openFPGALoader -c usb-blaster image.bit
```

Program the flash MMOD:

```
openFPGALoader -f -c usb-blaster images/bootloader/tinydfu_schoko.bit
```

## Blinky 

Building the blinky example requires [Yosys](https://github.com/YosysHQ/yosys), [nextpnr-ecp5](https://github.com/YosysHQ/nextpnr) and [Project Trellis](https://github.com/YosysHQ/prjtrellis).

Assuming they are installed, you can simply type `make` to build the gateware, which will be written to output/blinky.bin. You can then use [openFPGALoader](https://github.com/trabucayre/openFPGALoader) or dfu-util to write the gateware to the device.

## Linux

### Prebuilt Images

Copy the files from the `images/linux` directory to the root directory of a FAT-formatted MicroSD card.

Schoko ships with LiteX gateware on the user gateware section of the MMOD that is compatible with these images. If you plug a USB-UART into PMODA you should be able to interact with LiteX and view the Linux boot messages. After several seconds the Linux penguin should appear on the screen (HDMI) followed by a login prompt.

You can switch to the VGA gateware with:
 
```
$ sudo dfu-util -a 0 -D images/v1_vga/schoko.bit
```

Note: It should be possible to store the Linux images on the MMOD itself and boot Linux without any MicroSD card but this is not yet supported.

### Building Linux

Please follow the setup instructions in the [linux-on-litex-vexriscv](https://github.com/litex-hub/linux-on-litex-vexriscv) repo and then:

1. Build the Linux-capable gateware:

```
$ cd linux-on-litex-vexriscv
$ ./make.py --board schoko --uart-baudrate 1000000 --build
$ ls build/schoko
```

2. Write the gateware to the MMOD using USB DFU:

```
$ sudo dfu-util -a 0 -D build/schoko/gateware/schoko.bit
```

3. Copy the device tree binary `build/schoko/schoko.dtb` to a FAT-formatted MicroSD card.

4. Build the Linux kernel and root filesystem:

```
$ cd ..
$ git clone http://github.com/buildroot/buildroot
$ cd buildroot
$ make BR2_EXTERNAL=../linux-on-litex-vexriscv/buildroot/ litex_vexriscv_usbhost_defconfig
```

Optionally customize the kernel and buildroot packages:

```
$ make menuconfig
```

Build the kernel and rootfs:

```
$ make
$ ls output/images
```

5. Copy the `Image` and `rootfs.cpio` files from output/images to the MicroSD card.

6. Copy the OpenSBI binary (included in this repo as `schoko/images/linux/opensbi.bin`) to the MicroSD card. Alternatively, you can build this binary by following [these instructions](https://github.com/litex-hub/linux-on-litex-vexriscv#-generating-the-opensbi-binary-optional).

7. Copy `schoko/images/linux/boot.json` to the MicroSD card.

8. Power-cycle Schoko and if a USB-UART PMOD is attached to PMODA you should see the LiteX memory test and then the Linux boot messages. After Linux has finished booting you should see a login prompt on the serial console and the HDMI display.

## LiteX

### Installing LiteX

If you haven't yet installed LiteX please see the [LiteX quick start guide](https://github.com/enjoy-digital/litex#quick-start-guide) for details on installing LiteX.

### Building Custom Gateware

Build the LiteX gateware:

```
$ cd litex-boards/litex_boards/targets
$ ./machdyne_schoko.py --cpu-type=vexriscv --cpu-variant=lite --sys-clk-freq 40000000 --uart-baudrate 1000000 --uart-name serial --build
```

Program the LiteX gateware to SRAM over JTAG:

```
$ ./machdyne_schoko.py --cable usb-blaster --load
```

Or program the LiteX gateware to flash over DFU:

```
$ sudo dfu-util -a 0 -D build/machdyne_schoko/gateware/machdyne_schoko.bit
```

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

## Board Revisions

| Revision | Notes |
| -------- | ----- |
| V0 | Internal prototype |
| V1 | Initial production boards |
| V1A | Identical to V1 except for minor aesthetic changes on the silkscreen |

