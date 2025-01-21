/*
rotate it
use a screw or double sided tape
hide puck
*/

$fa = .01;
$fs = 1;

loose = .4;

pro = true;

case_width = pro ? 64 : 45.2;
case_length = 21.7;
case_height = pro ? 49 : 40; // todo
case_radius = case_length / 2;

puck_diameter = 57; //todo
puck_thickness = 5.5; //todo

wall_thickness = 3;

tooth_gap = 30;
tooth_curl = 3;

module case(offset = 0) {
  //%cube([case_width+2*offset, case_length+2*offset, case_height+2*offset], center=true);
  dx = case_width / 2 - case_radius;
  dz = case_height / 2 - case_radius;
  hull()
    for (i = [- 1, 1], j = [- 1, 1])
      translate([i * dx, 0, j * dz])
        sphere(r = case_radius + offset);
}
module clipping() {
  difference() {
    hull() {
      case(wall_thickness);
    rotate([90, 0, 0])
      translate([0, 0, case_radius])
        cylinder(d = puck_diameter + 2 * wall_thickness, h = puck_thickness + wall_thickness);
    }
    //hollow
    case();
    //cut off front
    translate([0, 100 + tooth_curl, 0])
      cube(200, center = true);

    //cut out teeth
    translate([0, tooth_gap / 2 - case_radius, 0])
      cylinder(d = tooth_gap, h = case_height * 2, center = true);
    translate([0, tooth_gap / 2 - case_radius, 0])
      rotate([0, 90, 0])
        cylinder(d = tooth_gap, h = case_height * 2, center = true);

    //shadow puck
//    %rotate([- 90, 0, 0])
//      translate([0, 0, - case_radius - puck_thickness]) cylinder(d = puck_diameter, h = puck_thickness + .1);
  }
}

module twisted_puck_negative(){
  hull(){
    n=ceil(puck_thickness/$fs);
    for(i=[0:n-1])
      translate([puck_diameter/2,0,puck_thickness])
        rotate([0,puck_thickness/(2*PI*puck_diameter)*360*i/(n-1),0])
          translate([-puck_diameter/2,0,-puck_thickness])
            cylinder(d = puck_diameter, h = puck_thickness + .1);
  }
}


module hanging() {
  difference() {
    hull() {
      case(wall_thickness);
      rotate([90, 0, 0])
        translate([0, 0, case_radius])
          cylinder(d = puck_diameter + 2 * wall_thickness, h = puck_thickness + wall_thickness);
      //squarish extension
      rotate([90, 0, 0])
        linear_extrude(case_radius + puck_thickness + wall_thickness)
          projection()
            rotate([90, 0, 0])
              case(wall_thickness);
    }
    //hollow
    case();
    //cut off front
    translate([0, 100 - case_radius, 100 - case_height / 6]) cube(200, center = true);

    //cut out puck
    rotate([- 90, 0, 0])
      rotate([0,0,90])
      translate([0, 0, - case_radius - puck_thickness])
        twisted_puck_negative();

    //cut out keychain
    slot_width=case_width/3;
    slot_depth=2/3*case_length+wall_thickness;
    translate([-slot_width/2,case_radius+wall_thickness-slot_depth,-99])cube([slot_width,slot_depth,99]);
    translate([-puck_thickness/2,-case_length/2-puck_thickness,-99])cube([puck_thickness,case_length,99]);
  }

  //shadow puck
  %rotate([- 90, 0, 0])
    translate([0, 0, - case_radius - puck_thickness + .1])
      cylinder(d = puck_diameter - 1, h = puck_thickness);
}

//rotate([0,0,180])clipping();

rotate([0,0,180]) hanging();