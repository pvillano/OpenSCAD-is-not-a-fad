$fa = .01;
$fs = 1;
ep = $preview ? .1 : .01;

// CAD measurements

pcb_xs = [19.050, 61.317, 109.240, 119.360, 171.450]; // 171.450=9*19.05
pcb_ys = [-2.381, 111.919, 116.979]; // pcb is short on the bottom by 7.025-4.644 = 2.381mm
pcb_z = 1.50;

// cherry spec
pcb_top_to_plate_top = 2.5;
plate_thickness = 1.2;
key_spacing = 19.05;
key_cutout_w = 14.00;
key_prong_w = 14.70;
//pin1xy = [-3, 2] * 1.27;
//pin2xy = [2, 4] * 1.27;
pin1xy = [0, 6.05];
pin2xy = [4.13, 3.3];


// Caliper measurements

usb_pcb_thicc = 3.14;
usb_pcb_width = 18.53;

stud_diameter = 4.0;
stud_locations = [
    [1, 1], [1, 2], [1, 3], [1, 4],
    [3, 1], [3, 2], [3, 3], [3, 5],
    [6, 1], [6, 2], [6, 3], [6, 5],
    [8, 1], [8, 2], [8, 4], [8, 5],
  ];

// design measurements
midpad_thickness = .6;

%translate([-47.62496, 159.5439, 0])import("bfo9000.stl");

module plate() {
  translate([0, 0, pcb_z])difference() {
    translate([0, pcb_ys[0], 0])
      cube([pcb_xs[4], pcb_ys[1] - pcb_ys[0], pcb_top_to_plate_top + midpad_thickness]);
    for (i = [0:8], j = [0:5]) {
      x = key_spacing * (.5 + i);
      y = pcb_ys[0] + key_spacing * (.5 + j);
      translate([x, y, 0]) {
        translate([0, 0, midpad_thickness])
          linear_extrude(pcb_top_to_plate_top + ep)
            square([key_cutout_w, key_cutout_w], center = true); // main cutout
        translate([0, 0, -ep])
          cylinder(d = 4, h = midpad_thickness + 2 * ep); // center stud
        translate([pin1xy[0], pin1xy[1], -ep])
          cylinder(d = 1.5, h = midpad_thickness + 2 * ep); // pin 1
        translate([pin2xy[0], pin2xy[1], -ep])
          cylinder(d = 1.5, h = midpad_thickness + 2 * ep); // pin 2

      }
    }
  }
}

plate();