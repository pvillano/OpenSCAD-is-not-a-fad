include <gridfinity-rebuilt-openscad/src/core/standard.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <gridfinity-rebuilt-openscad/src/core/bin.scad>

/* [Design Parameters] */
bit_count = 2;
box_gap = 4;
removal_tilt = 40; // [0:5:90]
removal_fulcrum = .37; // [0:.5]

/* [Label] */
font_height = 14;
font_width = 14;
starting_number = 1;

/* [Box Measurements] */
box_length = 70;
box_width = 14;

/* [Bit Measurements] */
// loose fit for collar diameter
collar_od = 8.5;
collar_h = 6;
// loose fit for bit diameter
bit_clearance_d=5;
//max length the bit sticks out past the collar
bit_shoulder=33;

/* [General Settings] */
// number of bases along y-axis
gridy = 1;
// bin height. See bin height information and "gridz_define" below.
gridz = 5;

/* [Toggles] */
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// how should the top lip act
style_lip = 0; //[0: Regular lip, 1:remove lip subtractively, 2: remove lip and retain height]

/* [Other] */
// How "gridz" is used to calculate height.  Some exclude 7mm/1U base, others exclude ~3.5mm (4.4mm nominal) stacking lip.
gridz_define = 0; // [0:7mm increments - Excludes Stacking Lip, 1:Internal mm - Excludes Base & Stacking Lip, 2:External mm - Excludes Stacking Lip, 3:External mm]

/* [Base] */
// thickness of bottom layer
bottom_layer = 1;


module _(){}
// Half grid sized bins.  Implies "only corners".
half_grid = false;

$fa = .01;
$fs = .3;


// number of bases along x-axis
gridx = 3;


/* [Base Hole Options] */
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = false;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = true;
// Base will have holes for M3 screws.
screw_holes = true;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = true;
// Magnet/Screw holes will have a chamfer to ease insertion.
chamfer_holes = true;
// Magnet/Screw holes will be printed so supports are not needed.
printable_hole_top = true;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_holes, printable_hole_top);

// ===== IMPLEMENTATION ===== //

binL = new_bin(
  grid_size = [gridx, gridy],
  height_mm = height(gridz, gridz_define, enable_zsnap),
  include_lip = style_lip == 0,
  hole_options = undef,//hole_options,
  only_corners = only_corners || half_grid,
  grid_dimensions = GRID_DIMENSIONS_MM / (half_grid ? 2 : 1),
  base_thickness = bottom_layer
);

chamferx2 = (collar_od-bit_clearance_d);
module bitHole(){
  //top chamfer
  cylinder(d1=collar_od+chamferx2,d2=collar_od,h=chamferx2/2);
  //collar slot
  cylinder(d=collar_od, h=collar_h);
  //transition
  translate([0,0,collar_h])
    cylinder(d1=collar_od, d2=bit_clearance_d, h=(collar_od-bit_clearance_d)/2);
  //slot for bit
  cylinder(d=bit_clearance_d, h=bit_shoulder);
}



// we have 120 mm to work with
x_room = 120;
chamfered_od = collar_od + chamferx2;
x_spacing = (x_room - chamfered_od - box_length - font_width)/4;

bin_render(binL){
  //z zero is top surface


  //check that bit doesn't poke through bottom
  translate([-x_room/2+chamfered_od/2+x_spacing,0,-2])mirror([0,0,1]) %bitHole();

  for(i=[0:bit_count-1]) translate([0,-(i-(bit_count-1)/2)*(box_width+box_gap),0]){
    translate([-x_room/2,0,0]){
      // bit holder
      off = chamfered_od/2+x_spacing;
      translate([off,0,0]) mirror([0,0,1]){
        bitHole();
      }

      //label
      off1 = off + chamfered_od/2+x_spacing+font_width/2;
      translate([off1,0,0])
      mirror([0,0,1])
        linear_extrude(1.4)
        text(str(i+starting_number), font_height, halign="center", valign="center");

      off2 = off1 +font_width/2+x_spacing;
      translate([off2,-box_width/2, -box_width]) union(){
        //base slot
        cube([box_length, box_width, box_width]);

        // extra vertical spot
        translate([(1-removal_fulcrum)*(box_length)/2-box_width/2,0,-19])
          cube([box_width, box_width, box_length]);
        //chamfer
        translate([(1-removal_fulcrum)*(box_length)/2,0,-box_width*.7])
          rotate([0,-45,0])
          cube(box_width);

        // wiggle room
        wiggle_ratio = removal_fulcrum;
        wiggle_radius = norm([box_length*wiggle_ratio,box_width]);

        // tiltability
        translate([(1-wiggle_ratio)*box_length,0,0]) {
          intersection() {
            //full sweep
            rotate([-90, 0, 0]) cylinder(r = wiggle_radius, h = box_width);
            //crop height
            translate([0, 0, -wiggle_radius]) cube([wiggle_radius, box_width, wiggle_radius + box_width]);
            //crop angle
            rotate([0, removal_tilt, 0]) translate([-wiggle_radius, 0, 0]) cube([2 * wiggle_radius, box_width,
              wiggle_radius]);
          }

          // tiltability affordance
          difference() {
            //full sweep
            translate([0, -box_gap / 2,0 ]) rotate([-90, 0, 0]) cylinder(r = wiggle_radius, h = box_width + box_gap);

            //remove center, leave bevel
            translate([0, -box_gap / 2-.1,0 ]) rotate([-90, 0, 0]) cylinder(r=box_width,h=box_width+box_gap+.2);

            rotate([0, removal_tilt, 0])
              translate([0, -box_gap / 2-.1, -2*wiggle_radius+box_width])
              cube([2 * wiggle_radius, box_width + box_gap+.2, 2 * wiggle_radius]);

            translate([-wiggle_radius, -box_gap / 2-.1, -wiggle_radius]) cube([wiggle_radius,wiggle_radius,2*wiggle_radius]);
          }
          difference(){
          }
        }
      }
    }
  }
}
