$fs = $preview ? 10 : 1;

// should include slop!
h_soap = 15;
// should include slop!
d_soap = 40;
wall_thickness = 4;

h_magnet = 2;
d_magnet = 4;

hole_spacing = 15;
hole_percent = 75;
/*
# travel soap container
draining epoxy-coated travel soap bar container

## constraints
I want to make something to hold my travel soap bars with the following constraints
1. waterproof - sealed with epoxy resin
2. draining
3. compact
4. sealed completely when closed
5. doesn't drain on top of eachother
6. needs to hold 3 pucks: soap, shampoo, conditioner

## ideation
* so one design could be like stacking cups with two diameters, holes on the bottom and a lid on top.
    * the bottommost one needs an extra lid for transport
* what if there was a shaft that the holders swung out from?
* what if I got some tins -> no draining
* what if it was held together with magnets? then I wouldn't have to worry about expoxy affecting clearances

## final design
five parts: a top lid, three chambers and a bottom lid. hexagons, just for funsies

##for version 2
the chambers could have three sloping feet that nest with the chamber below. one traingle wave
 */

d_hex = (d_soap + 2 * wall_thickness) / cos(30);
module lid() {
    difference() {
        cylinder(d = d_hex, h = wall_thickness, $fn = 6);
        if ($preview)
            translate([0, 0, - .1])
                cylinder(d = d_soap, h = .2);
        //holes for magnets
        for (theta = [60:60:360]) {
            dx = (d_hex + d_soap) / 2 / 2;
            rotate([0, 0, theta])
                translate([dx, 0, - .1])
                    cylinder(d = d_magnet, h = h_magnet + .1);
        }
    }
}

module chamber() {
    difference() {
        //outer hexagon
        cylinder(d = d_hex, h = wall_thickness + h_soap, $fn = 6);
        //void
        translate([0, 0, wall_thickness])
            cylinder(d = d_soap, h = h_soap + .2);
        //holes at the bottom
        translate([0, 0, - .1]) intersection() {
            cylinder(d = d_soap, h = wall_thickness + .2);
            for (i = [- 5:5], j = [- 5:5]) {
                rotate([0,0,30])
                translate([hole_spacing * i, 0, 0])
                    rotate([0, 0, 60])
                    translate([j*hole_spacing,0,0])
                    rotate([0, 0, 30])
                    cylinder(d = hole_spacing * hole_percent / 100 / cos(30), h=wall_thickness+.2,  $fn = 6);
            }
        }
        //holes for magnets
        for (theta = [60:60:360]) {
            dx = (d_hex + d_soap) / 2 / 2;
            rotate([0, 0, theta]) {
                translate([dx, 0, - .1])
                    cylinder(d = d_magnet, h = h_magnet + .1);
                translate([dx, 0, h_soap + wall_thickness - h_magnet])
                    cylinder(d = d_magnet, h = h_magnet + .1);
            }
        }
    }
}

//lid();
chamber();