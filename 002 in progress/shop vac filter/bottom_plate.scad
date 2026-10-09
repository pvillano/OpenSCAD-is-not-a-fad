
outer_diameter = 210;
h = 12;
depth = 3;
layer_height = .35;
cell_width = 5;
nozzle_diameter = .6;

module _(){}

$fs = 1.;
$fa = .01;

pi=3.14;
sector_count = round(pi*outer_diameter/cell_width/2)*2+1;

module matingSpike(){
  linear_extrude(5, scale=.8){
    square([depth-nozzle_diameter, cell_width-nozzle_diameter], center=true);
  }
}

module matingRing(){
  for(i=[0:sector_count-1]){
    rotate([0,0,i*360/sector_count])
    translate([(outer_diameter-depth)/2,0,0])
    matingSpike();
  }
}

module nutHole() translate([0,0,-.01]){
  waf = 7/16*25.4;
  nut_h = 7/32*25.4 + 1;
  od = waf/cos(30);
  rod_od = 1/4 * 25.4 + 1; // 1/4-20 rod with 1 mm clearance
  cylinder(d=od, h=nut_h, $fn=6);
  cylinder(d=rod_od, h=30);
}

difference(){
  union(){
    translate([0,0,h]) matingRing();
    cylinder(d=outer_diameter,h=h);
  }
  nutHole();
}
