/*
 * Schoko Case
 * Copyright (c) 2022 Lone Dynamics Corporation. All rights reserved.
 *
 */

$fn = 100;

mach_edition = false;

board_width = 50;
board_thickness = 1.5;
board_length = 100;
board_height = 20;
board_spacing = 2;

ldx_board();

translate([0,0,15])
	ldx_case_top();

translate([0,0,-15])
	ldx_case_bottom();

module ldx_board() {
	
	difference() {
		color([0,0.5,0])
			roundedcube(board_width,board_length,board_thickness,3);
		translate([5, 5, -1]) cylinder(d=3.2, h=10);
		translate([5, 95, -1]) cylinder(d=3.2, h=10);
		translate([45, 5, -1]) cylinder(d=3.2, h=10);
		translate([45, 95, -1]) cylinder(d=3.2, h=10);
	}	
	
}

module ldx_case_top() {

	union() {
	
		// support between pmods
		translate([0,50-3.5,0])
				cube([5,7.5,14.5]);

		// support above usb host port
		if (mach_edition) {
			translate([25-(14.5/2),-1,7.5]) cube([14.5,10,8.5]);
		} else {
			translate([25-(14.5/2),0,7.5]) cube([14.5,10,7.5]);
		}
		
		difference() {

			union () {
			
				color([0.5,0.5,0.5])
					roundedcube(board_width,board_length,15,3);

				if (mach_edition) {
					translate([-1,board_length-15+1,6])
						cube([board_width+2,4,10]);
					translate([-1,board_length-20+1,6])
						cube([board_width+2,4,10]);
					translate([-1,board_length-25+1,6])
						cube([board_width+2,4,10]);
				}
			
			}
	
			translate([1.5,2,-2.8])
				roundedcube(board_width-3,board_length-4,6,3);

			translate([1.5,10,-2])
				roundedcube(board_width-8,board_length-63.7,15,3);

			translate([1.5,2,-2])
				roundedcube(board_width-11.5,board_length-4,15,5);

			// vent
			translate([-1,board_length-15,10])
				cube([(board_width/2)-8,1,8]);		
			translate([(board_width/2)+8,board_length-15,10])
				cube([(board_width/2)-8,1,8]);

			translate([-1,board_length-20,10])
				cube([(board_width/2)-8,1,8]);		
			translate([(board_width/2)+8,board_length-20,10])
				cube([(board_width/2)-8,1,8]);

			if (!mach_edition) {

				translate([-1,board_length-25,10])
					cube([(board_width/2)-8,1,8]);		
				translate([(board_width/2)+8,board_length-25,10])
					cube([(board_width/2)-8,1,8]);
			
			}

			// LED vent
			translate([-1,board_length-80,5])
				cube([board_width-10,2,2]);

			translate([-1,board_length-85,5])
				cube([board_width-10,2,2]);

			translate([-1,board_length-90,5])
				cube([board_width-10,2,2]);
		
			// VGA
			translate([30,26.23-(31/2),-2]) cube([30,31,12.5+2]);

			// DDMI
			translate([30,60.8-(15.8/2),-2]) cube([30,15.8,5.5+2]);

			// USBC
			translate([30,84.3-(9.5/2),-2]) cube([30,9.5,3.5+1.75]);

			// USBA HOST
			translate([25-(14.5/2),-2,-2]) cube([14.5,30,7.5+2]);
		
			// SD
			translate([25-(15/2),90,-2]) cube([15,30,2+2]);

			// SD resistor cutouts
			translate([8,74,-2]) cube([15,10,2+2]);
			translate([17,74,-2]) cube([15,10,2+2]);

			// PMODA
			translate([0,45.095-(13.05/2),0]) cube([5,16,10],center=true);

			// PMODB
			translate([0,67.955-(13.05/2),0]) cube([5,16,10], center=true);
		
			// bolt holes
			translate([5, 5, -21]) cylinder(d=3.5, h=40);
			translate([5, 95, -21]) cylinder(d=3.5, h=40);
			translate([45, 5, -20]) cylinder(d=3.5, h=40);
			translate([45, 95, -21]) cylinder(d=3.5, h=40);

			// flush mount bolt holes
			translate([5, 5, 14]) cylinder(d=5, h=4);
			translate([5, 95, 14]) cylinder(d=5, h=4);
			translate([45, 5, 14]) cylinder(d=5, h=4);
			translate([45, 95, 14]) cylinder(d=5, h=4);

			// schoko text
			rotate(270)
				translate([-40,25-3,14])
					linear_extrude(5)
						text("S C H O K O", size=6, halign="center",
							font="Ubuntu:style=Bold");

		}	
	
	}

}

module ldx_case_bottom() {
	
	difference() {
		color([0.5,0.5,0.5])
			roundedcube(board_width,board_length,8.5,3);
		
		translate([2,10,2])
			roundedcube(board_width-4,board_length-20,8,3);
				
		translate([10,2.5,2])
			roundedcube(board_width-20,board_length-5,8,3);

		// bolt holes
		translate([5, 5, -11]) cylinder(d=3.2, h=25);
		translate([5, 95, -11]) cylinder(d=3.2, h=25);
		translate([45, 5, -11]) cylinder(d=3.2, h=25);
		translate([45, 95, -11]) cylinder(d=3.2, h=25);

		// nut holes
		translate([5, 5, -1.5]) cylinder(d=7, h=4.5, $fn=6);
		translate([5, 95, -1.5]) cylinder(d=7, h=4.5, $fn=6);
		translate([45, 5, -1.5]) cylinder(d=7, h=4.5, $fn=6);
		translate([45, 95, -1.5]) cylinder(d=7, h=4.5, $fn=6);

	}	
}

// https://gist.github.com/tinkerology/ae257c5340a33ee2f149ff3ae97d9826
module roundedcube(xx, yy, height, radius)
{
    translate([0,0,height/2])
    hull()
    {
        translate([radius,radius,0])
        cylinder(height,radius,radius,true);

        translate([xx-radius,radius,0])
        cylinder(height,radius,radius,true);

        translate([xx-radius,yy-radius,0])
        cylinder(height,radius,radius,true);

        translate([radius,yy-radius,0])
        cylinder(height,radius,radius,true);
    }
}
