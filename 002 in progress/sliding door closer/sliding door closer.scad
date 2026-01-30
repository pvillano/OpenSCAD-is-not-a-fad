/**
*
* must not slam door
* use a windmill as a governer
* governer only operates when
* timing belt would be funny
* probably just use white rope

* shaft rotates with pulley wheel
* front of shaft attached to governer with a one-way bearing
* shaft rotates freely in housing
*/


/* [Bearings] */
bearing_id = 8;
bearing_od = 22;
bearing_width = 9;
keyway = 2; //todo

/* [Pulley] */
pulley_od = 75;
pulley_width = 8;
groove_depth = 1;
groove_diameter = 4;

/* [Housing] */

pulley_wall_offset = 25;
shaft_length = 100;

/* [Governer] */
governer_od = 150;

/* [Clip-on thingy] */
flatbar_witdh = 25.4;
flatbar_thickness = 7;


module fillet(r) {
  offset(r = r) offset(delta = -r) children();
}

$fa = .01;
$fs = 1;

module torus(major_r, minor_r) {
  rotate_extrude() translate([major_r, 0, 0]) circle(r = minor_r);
}

module circular_pattern(n) {
  for (i = [0:n - 1])
  rotate([0, 0, i / n * 360]) children();

}

module pulley() {
  difference() {
    // body
    cylinder(d = pulley_od, h = pulley_width, center = true);
    //groove
    torus(pulley_od / 2 + groove_diameter / 2 - groove_depth, groove_diameter / 2);
    //shaft hole
    cylinder(d = bearing_id, h = pulley_width + .02, center = true);
    //keyway
    translate([bearing_id / 2, 0, 0])
      cube([keyway, keyway, pulley_width + .02], center = true);
  }
}

module housing() {
  housing_width = pulley_od + bearing_id * 6;
  pillar_offset = (housing_width - 3 * bearing_id) / 2;
  housing_thickness = bearing_width;
  linear_extrude(housing_thickness) {
    difference() {
      //base
      fillet(bearing_id * 1.5)
      square(housing_width, center = true);
      //pillar holes
      circular_pattern(4)
      translate([pillar_offset, pillar_offset])
        circle(d = bearing_id);
      //bearing hole
      circle(d = bearing_od);
    }
  }
}

module governer() {
  difference() {
    union() {

      //flat section
      linear_extrude(.6) {
        difference() {
          square(200, center = true);

          //slits
          circular_pattern(4)
          rotate(45)
            translate([40, 0])
              square([200, 2]);
        }
      }
      //locking tabs
      linear_extrude(5) {
        circular_pattern(4){
          intersection() {
            //discs
            translate([100, 100]) circle(22);
            //outer boundry
            square(200, center = true);
            //45
            rotate(-45) square(150);
          }
        }
      }
      //hub
      linear_extrude(bearing_width + 5) {
        difference() {
          circle(d = bearing_od + 2 * 4);
        }
      }
    }
    // extra subtractions
    translate([0,0,-.01])linear_extrude(bearing_width + 5 + .02) {
      circle(d = bearing_od);
      translate([bearing_od / 2, 0]) square(keyway, center = true);
    }
  }
}

module clip() {}


translate([0, 0, 17]) governer();
translate([0, 0, 5]) housing();
pulley();
translate([0, 0, -14]) housing();