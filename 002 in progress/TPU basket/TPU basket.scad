$fa=.01;
$fs=.5;

branches = 9;
bed_diameter = 200;
diameter = 75;
width=4;
thickness=1.75;

module main(){

cylinder(d=diameter, h=thickness, $fn=branches);
for(i=[0:branches-1])
  rotate([0,0,i*360/branches])
  translate([0,-width/2,0])
  cube([bed_diameter/2, width,thickness]);
starter_diameter =2*thickness+1/75;
translate([diameter/2,0,thickness+1.75/2])
  rotate([90,0,0])
  difference(){
    cylinder(h=width,d=starter_diameter, center=true);
    cylinder(h=width+.1,d=1.75, center=true);
  }
}

n=5;
starter_diameter =2*thickness+1/75;
for(i=[0:n]){
  translate([i*starter_diameter+i*(i+1)*.1,0,1.75+i*.1])rotate([90,0,0])
  difference(){
    union(){
      translate([0,-starter_diameter/4-i*.05,0])
        cube([starter_diameter+i*.2+1,starter_diameter/2+i*.1,width], center=true);
    cylinder(h=width,d=starter_diameter+i*.2, center=true);
    }
    cylinder(h=width+.1,d=1.75+i*.2, center=true);
  }
}