/* [Measurements] */

tape_id_inches = 3;
tape_thickness_inches = .95;
magnet_thickness = 5;
marker_diameter = 13;
magnet_hole_spacing = 50.7;
insert_diameter = 5.4;
insert_height = 6;

/* [Design Parameters] */
thin_wall_thickness = 1.2;
thick_wall_thickness = 3.5;
rim_depth = 4;
flap_gap_degrees = 5;
prong_count = 3;
slop = 1;

twt = thin_wall_thickness;
tape_thickness = tape_thickness_inches * 25.4 + 1;
tape_id = tape_id_inches * 25.4 - 1;


inner_barrel_radius = tape_id / 2 - twt - rim_depth;

$fs = 1;
$fa = .01;

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}

module wedge(r, angle) {
  intersection() {
    square(r);
    rotate(angle - 90) square(r);
    circle(r = r);
  }
}

module arc(r0, r1, angle) {
  difference() {
    wedge(max(r0, r1), angle);
    circle(r = min(r0, r1));
  }
}


module flat_body() difference() {
  union() {
    //base circle body
    circle(d = tape_id);
    //lil bumpouts for each prong
    for (a = [0:prong_count - 1])
    rotate(a * 360 / prong_count + flap_gap_degrees) intersection() {
      r = tape_id / 2 + rim_depth;
      dr = 15;
      wedge(tape_id / 2 + rim_depth, 180 / prong_count);
      translate([r - dr, 0]) circle(r = dr);
    }
  }

  for (a = [0:prong_count - 1])
  rotate(a * 360 / prong_count) {
    //space under prongs
    arc(tape_id / 2 - twt, inner_barrel_radius, 180 / prong_count);
    //space between tip of prong and next flat
    arc(tape_id / 2 + rim_depth + .1, inner_barrel_radius, flap_gap_degrees);
  }
}


render() difference() {
  linear_extrude(tape_thickness + 2 * thick_wall_thickness) flat_body();

  //space occupied by tape
  translate([0, 0, thick_wall_thickness]) {
    linear_extrude(tape_thickness) {
      difference() {
        circle(d = tape_id + rim_depth * 2 + .1);
        circle(d = tape_id);
      }
    }
  }
  //space occupied by marker
  hull() {
    translate([0, -inner_barrel_radius + marker_diameter / 2 + twt, marker_diameter / 2 + twt]) {
      #sphere(d = marker_diameter);
    }
    translate([0, inner_barrel_radius, tape_thickness + 2 * thick_wall_thickness + marker_diameter / 2])sphere(d = marker_diameter);
  }
  //space occupied by magnet
  linear_extrude(magnet_thickness) intersection() {
    translate([-tape_id/2, -tape_id/5, 0]) square(tape_id);
    circle(r = tape_id/2 - twt);
  }
  //magnet mounting holes
  mirror2([1, 0, 0]){
    translate([magnet_hole_spacing / 2, 0, 0]) cylinder(d = insert_diameter, h = insert_height + magnet_thickness);
  }

}
//#circle(d=67);
