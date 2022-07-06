
$fa=.01;
$fs= .1;
// non-design measurements
key_spacing = 19.05;
key_cutout_w = .551 * 25.4;

il = 59.7;//td
iw = 109;//td
ih = 35; //conservative
draft = 2.6;
//twall = 1.2;
r_corner=15;//17

twt=.86;

pcb_thickness = 1.62;

difference(){
	linear_extrude(pcb_thickness, center=true) offset(r=r_corner) square([iw-2*r_corner,il-2*r_corner], center=true);
	for(i=[-2:2],j=[-1:1])
		translate([key_spacing*i, key_spacing*j,0])
		cube([key_cutout_w,key_cutout_w,pcb_thickness+.2], center=true);
}

mirror([0,0,1])
	linear_extrude(ih,scale=(il-draft)/il)
	difference()
{
	offset(r=r_corner) square([iw-2*r_corner,il-2*r_corner], center=true);
	offset(r=r_corner-twt) square([iw-2*r_corner,il-2*r_corner], center=true);
}