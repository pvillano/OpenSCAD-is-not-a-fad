center_to_center = 51;
magnet_thickness = 4;
magnet_hole_spacing = 51;
id_inches = 3;
width_inches = 1;

max_od_inches = 5;

layer_height = .35;
finger_width = 25;
sharpie_od = 14;
cardboard_thickness = 2;
screw_usable= 16;
heatset_od = 5.5;
heatset_height = 6;

sharpie_fudge = .6;

id = id_inches * 25.4;
width = width_inches * 25.4;
max_od = max_od_inches * 25.4;
$fs = 1;
$fa = .01;

module main() {
  difference() {
    union() {
      //body
      translate([0, 0, -1])cylinder(d = id, h = width + 2);
      //top flange
      translate([0, 0, width]) cylinder(d = id + cardboard_thickness * 2, h = cardboard_thickness);
      //bottom flange
      translate([0, 0, -cardboard_thickness]) cylinder(d = id + cardboard_thickness * 2, h = cardboard_thickness);
      translate([max_od / 2 + finger_width, 0, 0]) cube(5);
    }
    //sharpie hole
    #hull() {
      translate([0, -id / 2 + sharpie_od / 2, sharpie_od / 2])sphere(d = sharpie_od);
      translate([0, id / 2+cardboard_thickness, width + sharpie_od / 2+cardboard_thickness+sharpie_fudge]) sphere(d = sharpie_od);
    }
    //split
    split_height = -cardboard_thickness+magnet_thickness+screw_usable-heatset_height;
    translate([0,0, split_height]) cube([id+4,id+4,.1], center=true);
    //magnet undercut
    translate([0,0,-cardboard_thickness-.1])cylinder(d=70,h=magnet_thickness+.1);
    //magnet holes
    mirror2([1,0,0]){
      //clearance
      translate([magnet_hole_spacing/2,0,-cardboard_thickness+magnet_thickness-.1]) cylinder(d=3.3,h=screw_usable);
      translate([magnet_hole_spacing/2,0,split_height]) cylinder(d=heatset_od, h=heatset_height);
    }


  }
}
module mirror2(xyz){
  mirror(xyz) children();
  children();
}

function pol2cart(r, theta) = [r * cos(theta), r * sin(theta)];

//module spiral_sector(r1, r2){
//  circumference_kinda = r2 * 6.28 / 4;
//  fn = round(circumference_kinda/$fs);
//  polygon([[0,0], each [for (i = [0:fn]) pol2cart(r1+i/fn*(r2-r1),i/fn*90)]]);
//}

module tape() {
  difference() {
    translate([0, 0, 1])cylinder(d = max_od, h = width - 2);
    translate([0, 0, -1]) cylinder(d = id + 2, h = width + 2);
  }
}
//
main();
%tape();
