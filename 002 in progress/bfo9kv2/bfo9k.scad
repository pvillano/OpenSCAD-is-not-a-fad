/*
TODO: belt redesign

Design decisions:
Tilting to make as thin as possible in the front introduces layer line terraces, so make it flat

*/


$fa = .01;
$fs = .5;
ep = $preview ? .1 : .01;

// CAD measurements

pcb_xs = [19.050, 61.317, 109.240, 119.360, 171.450]; // 171.450=9*19.05
pcb_ys = [-2.381, 111.919, 116.979]; // pcb is short on the bottom by 7.025-4.644 = 2.381mm
pcb_z = 1.50;

reset_x = 42.3;
reset_y = 113.7;

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
plate_top_to_prong_bottom = 5.75;
pcb_top_to_pin_bottom = 2.6;
// cherry
//pin1xy = [-3, 2] * 1.27;
//pin2xy = [2, 4] * 1.27;
pin1xy = [-2.78, 5.75]; // should actually be [-2.6, 5.75];
pin2xy = [4.40, 4.70];


// Caliper measurements

usb_pcb_thicc = 3.2;
usb_pcb_width = 18.53;
usb_pcb_length = 34.1;

pcb_type_c_height = 3.3;
pcb_type_c_y = 8;

diode_x = 5;
diode_y = 5;
diode_z = 1;

// design measurements
midpad_thickness = .6;
wall_thickness = 2;
thinnest_layer = .2;
slant_dz = .4;

xy_hole_slop = .5;

//derived dimensions

typec_width = pcb_xs[3] - pcb_xs[2];
stud_below_pcb_bottom = plate_top_to_prong_bottom - pcb_top_to_plate_top - pcb_z;
pin_below_pcb_bottom = pcb_top_to_pin_bottom - pcb_z;

slant_hyp = key_spacing;
slant_opp = slant_dz;
slant_adj = sqrt(slant_hyp^2 - slant_opp^2);
slant_angle = asin(slant_opp / slant_hyp);

// generic functions

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}


//design

module plate() {
  translate([0, 0, pcb_z]) difference() {
    translate([0, pcb_ys[0], 0])
      cube([pcb_xs[4], pcb_ys[2] - pcb_ys[0], pcb_top_to_plate_top + midpad_thickness]);


    for (i = [0:8], j = [0:5]) {
      x = key_spacing * (.5 + i);
      y = pcb_ys[0] + key_spacing * (.5 + j);
      translate([x, y, 0]) {
        //         //unsafe area
        //        %translate([0, 0, midpad_thickness + pcb_top_to_plate_top])
        //          linear_extrude(ep)
        //            square([15, 15], center = true);

        translate([0, 0, midpad_thickness])
          linear_extrude(pcb_top_to_plate_top + ep)
            square([key_cutout_w, key_cutout_w], center = true); // main cutout
        translate([0, 0, midpad_thickness])
          linear_extrude(pcb_top_to_plate_top - plate_thickness)
            square([key_prong_w, key_cutout_w], center = true); // prong cutout
        translate([0, 0, -ep])
          cylinder(d = 5 + xy_hole_slop, h = midpad_thickness + 2 * ep); // center stud
        translate([pin1xy[0], pin1xy[1], -ep])
          cylinder(d = 1.5 + xy_hole_slop, h = midpad_thickness + 2 * ep); // pin 1
        translate([pin2xy[0], pin2xy[1], -ep])
          cylinder(d = 1.5 + xy_hole_slop, h = midpad_thickness + 2 * ep); // pin 2
      }
    }

    for (xy = stud_locations) {
      x = xy[0] * key_spacing;
      y = xy[1] * key_spacing + pcb_ys[0];
      translate([x, y, 0]) {
        translate([0, 0, -ep]) cylinder(d = 3 + xy_hole_slop, h = pcb_top_to_plate_top + midpad_thickness + 2 * ep);
        translate([0, 0, pcb_top_to_plate_top + midpad_thickness - 1.7])cylinder(h = 1.7 + ep, d1 = 3 + xy_hole_slop, d2 = 6 + xy_hole_slop + ep);
      }
    }
  }
}

module base() {
  plate_stackup = pcb_top_to_plate_top + pcb_z + midpad_thickness;
  h2 = plate_stackup + thinnest_layer + max(usb_pcb_thicc, pcb_type_c_height);
  difference() {
    //    translate([0, 0 + pcb_ys[0], -h2 + plate_stackup])
    //      cube([pcb_xs[4], pcb_ys[2] - pcb_ys[0], h2]);
    hull() {
      #translate([0, pcb_ys[2] - usb_pcb_length, 0])
        rotate([-slant_angle, 0, 0])
          translate([0, usb_pcb_length - pcb_ys[2], 0])
            translate([0, 0 + pcb_ys[0], -h2 + plate_stackup])
              cube([pcb_xs[4], pcb_ys[2] - pcb_ys[0], ep]);
      translate([0, 0 + pcb_ys[0], -ep + plate_stackup])
        cube([pcb_xs[4], pcb_ys[2] - pcb_ys[0], ep]);
    }

    // plate
    translate([0 - ep, pcb_ys[0] - ep, pcb_z])
      cube([pcb_xs[4] + 2 * ep, pcb_ys[2] - pcb_ys[0] + 2 * ep+9.999, plate_stackup + ep+9.999]);

    //pcb
    translate([0 - ep, 0, 0])
      cube([pcb_xs[4] + 2 * ep, pcb_ys[1], pcb_z + ep]);
    //pcb left outdent
    translate([pcb_xs[0], pcb_ys[1] - ep, 0])
      cube([pcb_xs[1] - pcb_xs[0], pcb_ys[2] - pcb_ys[1] + 2 * ep, pcb_z + ep]);

    //pcb left outdent daughter
    translate([pcb_xs[0], pcb_ys[2] - usb_pcb_length, -usb_pcb_thicc])
      cube([key_spacing, usb_pcb_length + ep, usb_pcb_thicc + pcb_z + ep]);
    //pcb left outdent daughter
    //    %translate([pcb_xs[0], pcb_ys[2] - usb_pcb_length, -stud_below_pcb_bottom - usb_pcb_thicc])
    //      cube([key_spacing, usb_pcb_length + ep, usb_pcb_thicc]);

    //pcb left outdent typec
    #translate([pcb_xs[1] - typec_width, pcb_ys[2] - pcb_type_c_y, -pcb_type_c_height])
      cube([typec_width, pcb_type_c_y + ep, pcb_type_c_height + pcb_z + ep]);
    //pcb right outdent
    translate([pcb_xs[2], pcb_ys[1] - ep, 0])
      cube([typec_width, pcb_ys[2] - pcb_ys[1] + 2 * ep, pcb_z + ep]);
    //pcb right outdent typec
    #translate([pcb_xs[2], pcb_ys[2] - pcb_type_c_y, -pcb_type_c_height])
      cube([typec_width, pcb_type_c_y + ep, pcb_type_c_height + pcb_z + ep]);

    // per-key features
    for (i = [0:8], j = [0:5]) {
      x = key_spacing * (.5 + i);
      y = pcb_ys[0] + key_spacing * (.5 + j);
      translate([x, y, ep]) {
        mirror([0, 0, 1]) {
          // center stud
          cylinder(d = 5, h = stud_below_pcb_bottom + thinnest_layer + 2 * ep);
          %cylinder(d = 5, h = stud_below_pcb_bottom + 2 * ep);
          // pin 1
          translate([pin1xy[0], pin1xy[1], 0])
            cylinder(d1 = 3, d2 = 1.5, h = pin_below_pcb_bottom + ep);
          // pin 2
          translate([pin2xy[0], pin2xy[1], 0])
            cylinder(d1 = 3, d2 = 1.5, h = pin_below_pcb_bottom + ep);
        }
      }
    }

    //reset button hole
    translate([reset_x, reset_y, 0]) mirror([0, 0, 1]) {
      reset_diameter = 6.6;
      cube([9, reset_diameter, 2], center = true);
      linear_extrude(10) intersection() {
        square(reset_diameter, center = true);
        rotate(45) square(reset_diameter + .7, center = true);
      }
    }

    // smd diode cutouts
    intersection() {
      for (i = [0:9]) {
        translate([i * key_spacing, pcb_ys[1] / 2, 0])
          cube([diode_x, pcb_ys[1], diode_z * 2], center = true);
      }
      for (j = [0:5]) {
        translate([-ep, (j + .5) * key_spacing + pcb_ys[0] - diode_y / 2, -diode_z])
          cube([pcb_xs[4] + 2 * ep, diode_y, diode_z * 2]);
      }
    }

    // holes for m3 heatset inserts
    for (xy = stud_locations) {
      x = xy[0] * key_spacing;
      y = xy[1] * key_spacing + pcb_ys[0];
      translate([x, y, 0]) {
        translate([0, 0, ep]) mirror([0, 0, 1]) cylinder(d = 3 + xy_hole_slop, h = h2 - plate_stackup + 2 * ep);
        translate([0, 0, -(h2 - plate_stackup) - ep]) cylinder(h = 4 + ep, d = 4.2);
      }
    }

//    // holes for magnets
//    translate([pcb_xs[4] / 2, 0, 0])mirror2([1, 0, 0])translate([-pcb_xs[4] / 2, 0, 0]) for (j = [1:6]) {
//      h3 = h2 - plate_stackup ;
//      d = h3 - 2 * thinnest_layer;
//      y = j * key_spacing + pcb_ys[0];
//      translate([-ep, y, (plate_stackup - h2) / 2])
//        rotate([0, 90, 0]) {
//
//          rotate([0, 0, 360 / 16])cylinder(h = d / 2 + ep, d = d / cos(360 / 16), $fn = 8);
//          translate([0, 0, d / 2 + ep]) rotate([0, 0, 360 / 16]) sphere(d = d / cos(360 / 11.45), $fn = 8);
//          //#cylinder(h = d + ep, d = d);
//        }
//      echo(d);
//    }

    //    // bfo-9000 cutout (optional)
    //    translate([4.5*key_spacing,55.7,0]){
    //      cube([39,7,100], center=true);
    //    }

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
