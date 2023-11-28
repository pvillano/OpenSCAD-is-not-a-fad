$fa = .01;
$fs = .3;

inch = 25.4;

rod_diameter = 22;
paper_towel_height = 11 * inch;
paper_towel_diameter = 150;
paper_towel_inner_diameter = 40;
available_space = 173;
pyramid_compensation = 3;

magnet_1_dims = [62, 31];
magnet_1_holes = [[magnet_1_dims.x - 17, 7.5], [magnet_1_dims.x - 50.5, 8.5]];
magnet_2_dims = [68, 30];
magnet_2_holes = [[magnet_2_dims.x - 3.5, 7], [magnet_2_dims.x - 65, 6]];
magnet_margin = 1;
magnet_thickness = 6;

insert_diameter = 4.5;
insert_depth = 7;
twt = 2.5;
shadow_line = 1.5;

magnet_space = [
    max(magnet_1_dims.x, magnet_2_dims.x) + 2 * magnet_margin,
    max(magnet_1_dims.y, magnet_2_dims.y) + 2 * magnet_margin,
  ];

module torus (major_r, minor_r){
  rotate_extrude() translate([major_r, 0, 0]) circle(minor_r);
}

module magnet_test() {
  difference() {
    linear_extrude(2) square(magnet_space + 2 * twt * [1, 1], center = true);
    // screw holes
    mirror([1,0,0]){
      translate(magnet_1_holes[0] - .5 * magnet_1_dims) cylinder(d = insert_diameter, h = insert_depth);
      translate(magnet_1_holes[1] - .5 * magnet_1_dims) cylinder(d = insert_diameter, h = insert_depth);
      rotate(180) translate(magnet_2_holes[0] - .5 * magnet_2_dims) cylinder(d = insert_diameter, h = insert_depth);
      rotate(180) translate(magnet_2_holes[1] - .5 * magnet_2_dims) cylinder(d = insert_diameter, h = insert_depth);
    }
    // rod test fit
    cylinder(h = magnet_space.y + 2 * twt + .2, d = rod_diameter, center = true);
  }
}

module insert_test(){
  difference(){
    unit = insert_diameter + 2*twt;
    cube(unit * [3,1,1], center=true);
    for(i=[-1,0,1]){
      d=insert_diameter + i * .1;
      translate([i*unit,0,0]){
        rotate([90,0,0]) cylinder(d = d, h = insert_depth, center=true);
        translate([0,-unit/2,unit/2-twt/2]) rotate([90,0,0]) linear_extrude(.4, center=true) text(str(d), halign = "center", valign = "center", size = twt*.8);
      }
    }
  }
}

module roll(){
  %translate([0, 0, available_space/2]) rotate([- 90, 0, 0]) difference(){
    cylinder(h = paper_towel_height, d = paper_towel_diameter);
    translate([0,0,-.1]) cylinder(h = paper_towel_height+.2, d = paper_towel_inner_diameter);
  }
}

module main() {
  //height of center of rod
  h = available_space/2 + paper_towel_inner_diameter/2-rod_diameter/2;
  difference() {
    hull() {
      linear_extrude(.01) offset(twt) square([magnet_space.x + pyramid_compensation, magnet_space.y], center = true);
      //unround print-bed side corners
      translate([0,magnet_space.y/4,0]) linear_extrude(.01) offset(delta=twt) square([magnet_space.x + pyramid_compensation, magnet_space.y/2], center = true);
      translate([0, 0, h])
        rotate([-90, 0, 0])
          cylinder(h = magnet_space.y/2 + twt, d = rod_diameter + 2 * twt);
      translate([0, 0, h])rotate([-90, 0, 0])torus(rod_diameter/2, twt);
    }
    //hole for rod
    translate([0, 0, h])
      rotate([90, 0, 0])
        cylinder(h = magnet_space.y + 2 * twt + .2, d = rod_diameter, center = true);
    //empty space for magnets - shadow line!!!
    translate([0,0,-.1]) linear_extrude(magnet_thickness-shadow_line+.1) square(magnet_space, center = true);
    // screw holes
    mirror([1,0,0]){
      translate(magnet_1_holes[0] - .5 * magnet_1_dims) cylinder(d = insert_diameter, h = magnet_thickness+insert_depth-shadow_line);
      translate(magnet_1_holes[1] - .5 * magnet_1_dims) cylinder(d = insert_diameter, h = magnet_thickness+insert_depth-shadow_line);
      rotate(180) translate(magnet_2_holes[0] - .5 * magnet_2_dims) cylinder(d = insert_diameter, h = magnet_thickness+insert_depth-shadow_line);
      rotate(180) translate(magnet_2_holes[1] - .5 * magnet_2_dims) cylinder(d = insert_diameter, h = magnet_thickness+insert_depth-shadow_line);
    }
  }
  roll();
}
main();