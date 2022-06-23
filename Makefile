blinky_schoko:
	mkdir -p output
	yosys -q -p "synth_ecp5 -top blinky -json output/blinky_schoko.json" rtl/blinky_schoko.v
	nextpnr-ecp5 --45k --package CABGA256 --lpf schoko_v1.lpf --json output/blinky_schoko.json --textcfg output/schoko_blinky_out.config
	ecppack -v --compress --freq 2.4 output/schoko_blinky_out.config --bit output/schoko.bit

prog:
	openFPGALoader -c usb-blaster output/schoko.bit
