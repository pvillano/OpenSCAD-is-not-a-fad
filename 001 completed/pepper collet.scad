$fa=.01;
$fs= $preview ? 10: 1;
slop=.1;
w_shaft = 4.68+slop;
od=41.42;
tab_d=43.2;
tab_w=4.1;
id=36.60;
h_lip=1.1;
d_lip=44.15;
ih=10.82+2;

h=34;//ish

top_thickness=5;

module positive(){
	intersection(){
		cylinder(h=h,d=od);
		translate([0,0,-h])
			sphere(r=2*h);
	}
	intersection(){
		cylinder(h=4,d=tab_d);
		cube([tab_w, tab_d,8], center=true);
	}
	cylinder(d=d_lip,h=h_lip);
}

module negative()render(){
	h2= h-top_thickness;
	h1=ih;
	translate([0,0,-.1]){
		cylinder(h=h1+.1, d=id);
	}
	translate([0,0,h1]){
		cylinder(h=h2-h1, d1=id, d2=0);
	}
	cube([w_shaft, w_shaft,99], center=true);
}


rotate([0,0,360*$t])render() difference(){
	positive();
	negative();
	if($preview)
		translate([0,0,-1]) cube(999);
}
