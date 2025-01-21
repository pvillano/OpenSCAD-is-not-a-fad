$fa =.01;
$fs =.1;
BedWidth = 256;
Height = 40;
MinSpacing = 4;
density=1;

translate([0,0,-1])%square(BedWidth, center=true);

translate([-1,-1]*BedWidth/4) cylinder(d=BedWidth/2, h=1);
translate([-1, 1]*BedWidth/4) cylinder(d=BedWidth/2, h=1);
translate([ 1,-1]*BedWidth/4) cylinder(d=BedWidth/2, h=1);
translate([ 1, 1]*BedWidth/4) cylinder(d=BedWidth/2, h=1);

color("red")translate([-1, 1]*BedWidth/4) cylinder(d=BedWidth/2-MinSpacing*2, h=2);
color("red")translate([ 1,-1]*BedWidth/4) cylinder(d=BedWidth/2-MinSpacing*2, h=2);
color("red")translate([ 1, 1]*BedWidth/4) cylinder(d=BedWidth/2-MinSpacing*2, h=2);
color("red")translate([-1,-1]*BedWidth/4) cylinder(d=BedWidth/2-MinSpacing*2, h=2);
//my loop length 1428
//theirs 1139