$fa = .01 + 0;
$fs = 3;

/* [Design Parameters] */
h_transition = 30;
cap_height = 60;
cap_roundover_r = 10;
/* [Measurements] */
fan_width = 120;
screw_spacing = 105;
fan_thickness = 30;
fan_id1 = 117;
fan_id2 = 126;
filter_id = 118;
filter_od = 164;
rotor_d=40;


difference() {
  //domed outer body
  rotate_extrude() {
    square([filter_od / 2, cap_height - cap_roundover_r]);
    square([filter_od / 2 - cap_roundover_r, cap_height]);
    translate([filter_od / 2 - cap_roundover_r, cap_height - cap_roundover_r])
      circle(r = cap_roundover_r);
  }
  translate([0,0,h_transition]) linear_extrude(fan_thickness) {
    square(fan_width,center=true);
  }

  //fan air path transition
  #union() {
    hull() {
      translate([0, 0, h_transition])  linear_extrude(.1) intersection() {
        circle(d = fan_id2);
        square(fan_id1, center = true);
      }
      cylinder(d = filter_id, h = .1);
    }
  }
}


