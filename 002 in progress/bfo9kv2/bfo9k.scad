/*
TODO: add measurements of usb pcb
TODO: try shaving keyswitch studs shorter in daughter board area
TODO: smd allowance

With a friction fit on every stud,
there should be no problem keeping the two halves together
instead, the bottom and top should be plates, that extend slightly past the pcb
with the walls being a separate part made of e.g. petg

*/


$fa = .01;
$fs = 1;
ep = $preview ? .1 : .01;

// CAD measurements

pcb_xs = [19.050, 61.317, 109.240, 119.360, 171.450]; // 171.450=9*19.05
pcb_ys = [-2.381, 111.919, 116.979]; // pcb is short on the bottom by 7.025-4.644 = 2.381mm
pcb_z = 1.50;

stud_diameter = 4.0;
stud_locations = [
    [1, 1], [1, 2], [1, 3], [1, 4],
    [3, 1], [3, 2], [3, 3], [3, 5],
    [6, 1], [6, 2], [6, 3], [6, 5],
    [8, 1], [8, 2], [8, 4], [8, 5],
  ];

// Gateron spec
pcb_top_to_plate_top = 2.50;
plate_thickness = 1.20;
key_spacing = 19.05;
key_cutout_w = 14.00;
key_prong_w = 14.70;
pcb_top_to_prong_bottom = 5.75;
pcb_top_to_pin_bottom = 2.6;
// cherry
//pin1xy = [-3, 2] * 1.27;
//pin2xy = [2, 4] * 1.27;
pin1xy = [-2.78, 5.75]; // should actually be [-2.6, 5.75];
pin2xy = [4.40, 4.70];


// Caliper measurements

usb_pcb_thicc = 3.3;
usb_pcb_width = 18.53;
usb_pcb_length = 40; //todo

pcb_type_c_height = 2; //todo

// design measurements
midpad_thickness = .6;
wall_thickness = 2;
thinnest_layer = .2;

//derived dimensions

stud_below_pcb_bottom = pcb_top_to_prong_bottom - pcb_top_to_plate_top;
pin_below_pcb_bottom = pcb_top_to_pin_bottom - pcb_z;

// generic functions

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}


//design

module plate() {
  translate([0, 0, pcb_z])difference() {
    translate([0, pcb_ys[0], 0]) {
      cube([pcb_xs[4], pcb_ys[2] - pcb_ys[0], pcb_top_to_plate_top + midpad_thickness]);
      //      r = 3.05/2;//-2*pcb_ys[0];
      //      translate([r, r]) linear_extrude(pcb_top_to_plate_top + midpad_thickness)
      //        offset(r = r, $fn=16)
      //          square([pcb_xs[4] - 2*r, pcb_ys[2] - pcb_ys[0]-2*r]);
    }

    for (i = [0:8], j = [0:5]) {
      x = key_spacing * (.5 + i);
      y = pcb_ys[0] + key_spacing * (.5 + j);
      translate([x, y, 0]) {
        translate([0, 0, midpad_thickness])
          linear_extrude(pcb_top_to_plate_top + ep)
            square([key_cutout_w, key_cutout_w], center = true); // main cutout
        translate([0, 0, midpad_thickness])
          linear_extrude(pcb_top_to_plate_top - plate_thickness)
            square([key_prong_w, key_cutout_w], center = true); // prong cutout
        translate([0, 0, -ep])
          cylinder(d = 5, h = midpad_thickness + 2 * ep); // center stud
        translate([pin1xy[0], pin1xy[1], -ep])
          cylinder(d = 1.5, h = midpad_thickness + 2 * ep, $fn = 8); // pin 1
        translate([pin2xy[0], pin2xy[1], -ep])
          cylinder(d = 1.5, h = midpad_thickness + 2 * ep, $fn = 8); // pin 2
      }
    }

    for (xy = stud_locations) {
      x = xy[0] * key_spacing;
      y = xy[1] * key_spacing + pcb_ys[0];
      translate([x, y, 0]) {
        translate([0, 0, -ep]) cylinder(d = stud_diameter, h = pcb_top_to_plate_top + midpad_thickness + 2 * ep);
        //        translate([0, 0, pcb_top_to_plate_top + midpad_thickness - 1.7])cylinder(h = 1.7 + ep, d1 = 4, d2 = 6 + ep);
      }
    }
  }
}

module base() {
  plate_stackup = pcb_top_to_plate_top + pcb_z + midpad_thickness;
  h = plate_stackup + stud_below_pcb_bottom + thinnest_layer;
  difference() {

    translate([-wall_thickness, -wall_thickness + pcb_ys[0], -h + plate_stackup])
      cube([pcb_xs[4] + 2 * wall_thickness, pcb_ys[2] - pcb_ys[0] + 1 * wall_thickness, h]);

    //    hull() {
    //      dz = 1;
    //      translate([-wall_thickness, pcb_ys[2] + wall_thickness, plate_stackup-h-usb_pcb_thicc])
    //        cube([pcb_xs[4] + 2 * wall_thickness, ep, h + usb_pcb_thicc]);
    //      translate([-wall_thickness, -wall_thickness + pcb_ys[0], plate_stackup-h+dz])
    //        cube([pcb_xs[4] + 2 * wall_thickness, ep, h-dz]);
    //    }

    // plate
    translate([0, pcb_ys[0], pcb_z])
      cube([pcb_xs[4], pcb_ys[2] - pcb_ys[0] + ep, plate_stackup + ep]);

    typec_width = pcb_xs[3] - pcb_xs[2];
    //pcb
    translate([0, pcb_ys[0], 0])
      cube([pcb_xs[4], pcb_ys[1] - pcb_ys[0] + ep, plate_stackup + ep]);
    //pcb left outdent
    translate([pcb_xs[0], pcb_ys[1], 0])
      cube([pcb_xs[1] - pcb_xs[0], pcb_ys[2] - pcb_ys[1] + ep, pcb_z + ep]);
    //pcb left outdent daughter
    translate([pcb_xs[0], pcb_ys[2] - usb_pcb_length, -pcb_type_c_height])
      cube([key_spacing, usb_pcb_length + ep, pcb_type_c_height + pcb_z + ep]);
    //pcb left outdent typec
    translate([pcb_xs[1] - typec_width, pcb_ys[1], -pcb_type_c_height])
      cube([typec_width, pcb_ys[2] - pcb_ys[1] + ep, pcb_type_c_height + pcb_z + ep]);
    //pcb right outdent typec
    translate([pcb_xs[2], pcb_ys[1], -pcb_type_c_height])
      cube([typec_width, pcb_ys[2] - pcb_ys[1] + ep, pcb_type_c_height + pcb_z + ep]);


    for (i = [0:8], j = [0:5]) {
      x = key_spacing * (.5 + i);
      y = pcb_ys[0] + key_spacing * (.5 + j);
      translate([x, y, ep]) {
        mirror([0, 0, 1]) {
          // center stud
          cylinder(d = 5, h = stud_below_pcb_bottom + thinnest_layer + 2 * ep);
          // pin 1
          translate([pin1xy[0], pin1xy[1], 0])
            cylinder(d1 = 3, d2 = 1.5, h = pin_below_pcb_bottom + ep, $fn = 8);
          // pin 2
          translate([pin2xy[0], pin2xy[1], 0])
            cylinder(d1 = 3, d2 = 1.5, h = pin_below_pcb_bottom + ep, $fn = 8);
        }
      }
    }
  }
}

//%translate([-47.62496, 159.5439, 0])import("bfo9000.stl");
//plate();
difference() {
  base();
  //  cube(200, center = true);
}
//r = -pcb_ys[0];
//translate([r, r]) linear_extrude(pcb_top_to_plate_top + midpad_thickness)
//  offset(r = r, $fn=24)
//    square([pcb_xs[4], pcb_ys[2] - pcb_ys[0]]);