use <gridfinity_openscad/gridfinity_modules.scad>

base_or_insert = "base"; // ["base", "insert"]
/* [Gridfinity] */
num_x = 4;
num_y = 1;
hole_overhang_remedy = true;

/* [Inserts] */
num_inserts = 6;
dovetail_width = 15;
dovetail_angle = 18;
//Note: slop only affects insert
dovetail_slop = .03;
rail_height=2.5;
column_weight = .8; // [0:.1:.9]
//distance from top of roller to floor of container
roller_clearance=20;

/* [Bearings] */
bearing_id = 8;
bearing_od = 22;
bearing_width = 7;

/* [Hidden] */
$fa = 0.1;
$fs=.3;
//grid part is 4.75 high, unsafe zone is 7 high, inner height is 14, outer height is 17.75
num_z = 2; // ssh the model is fully parametric shh
//safety_gap=5.7; // this thick on the cup...which is too thin
safety_gap=7;
gridfinity_pitch = 42;
gridfinity_zpitch = 7;
gridfinity_clearance = 0.5;
gridfinity_wall_thickness=1.9; // I measured this in 3D Builder instead of reading

z_floor=(safety_gap+num_z*gridfinity_zpitch)/2; //average of lowest and highest possible
center_height = (roller_clearance-bearing_id/2)+(num_z*gridfinity_zpitch-safety_gap)/2;
column_width=min(dovetail_width*column_weight,bearing_od);

module dovetail(width, length, angle = 90, center = false) {
  rotate([90, 0, 180])linear_extrude(length, center = center)
    polygon([[- width / 2, 0], [width / 2, 0], [0, width / 2 * tan(90 - angle / 2)]]);
}
//!dovetail(10,30,15, center=false);

module mirror2(xyz){
  children();
  mirror(xyz) children();
}


module blockus() {
  difference() {
    grid_block(num_x = num_x, num_y = num_y, num_z = num_z, hole_overhang_remedy = hole_overhang_remedy);
    for (i = [0:num_inserts-1]) {
      //how many multiples of gridfinity_pitch to move in the x direction
      ii = -.5 + (i+.5)/num_inserts*num_x;
      translate([ii *gridfinity_pitch, -0.5*gridfinity_pitch, z_floor]){
        dovetail(dovetail_width, num_y * gridfinity_pitch, dovetail_angle);
        translate([-column_width/2,0,0]) cube([column_width,num_y * gridfinity_pitch,center_height]);
        translate([0,0,center_height])
          rotate([-90,0,0])
            cylinder(d=bearing_od+2*rail_height,h=num_y * gridfinity_pitch);
        //imaginary bearing
        %translate([0,0.5*gridfinity_pitch*num_y,center_height])
          rotate([-90,0,0])
          cylinder(d=bearing_od,h=bearing_width, center=true);
        //imaginary tushette
        %translate([0,.15*gridfinity_pitch,0]) tushette();
      }
    }
  }
  //imaginary spool
  i_hypot=100+bearing_od/2;
  i_base=gridfinity_pitch*num_x*(num_inserts-1)/num_inserts/2;
  i_height= sqrt(i_hypot^2-i_base^2) + center_height+z_floor;
  %translate([(num_x/2-.5)*gridfinity_pitch,0,i_height]) rotate([90,0,0]) cylinder(d=200,h=gridfinity_pitch*(num_y-.5),center=true, $fn=60);
}

module tushette(){
  rub_clearance=gridfinity_clearance;
  thickness=bearing_width/2+gridfinity_wall_thickness+gridfinity_clearance;

  cw2=column_width-dovetail_slop;

  translate([0,0,center_height]) rotate([-90,0,0]) cylinder(d=bearing_id-.1,thickness);
  //anti-rub step
  translate([0,0,center_height]) rotate([-90,0,0]) cylinder(d=bearing_id+2,gridfinity_wall_thickness+rub_clearance);
  intersection(){
      translate([0,0,center_height]) rotate([-90,0,0]) cylinder(d=bearing_od+2*rail_height-dovetail_slop, gridfinity_wall_thickness);
      cube([num_x*gridfinity_pitch/num_inserts-gridfinity_clearance,999,999], center=true);
  }
  difference(){
    union(){
      dovetail(dovetail_width-dovetail_slop, thickness, dovetail_angle);
      translate([-cw2/2,0,0]) cube([cw2,thickness,center_height]);
    }
    translate([0,0,center_height]) rotate([-90,0,0]) cylinder(d=bearing_od+gridfinity_clearance,thickness+.1);
    translate([0,0,999/2+center_height]) cube(999, center=true);
  }
}

if(base_or_insert=="base"){
  blockus();
} else{
  rotate([90,0,0])tushette(); 
}
