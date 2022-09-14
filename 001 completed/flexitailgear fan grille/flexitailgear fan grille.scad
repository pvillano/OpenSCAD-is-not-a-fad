
$fa = .01;
$fs = $preview ? 5 : .1;

od=20.2+.2;
twt=1.79;
h=3;
difference(){
	cylinder(h=h+twt,r=od/2+twt);
	translate([0,0,-.1]) cylinder(h=h+twt+.2,d=od);
}
translate([0,0,twt/2]) cube([od,twt,twt], center=true);
translate([0,0,twt/2]) cube([twt,od,twt], center=true);

