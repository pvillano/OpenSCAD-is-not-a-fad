fn=256;
dh=3;
min_d= 7.6;
max_d = 8;
n=10;
function lerp(a,b,t) = (1-t)*a + t*b; // = a + (b-a)*t

difference(){
	union() for(i=[0:n]) difference(){
		d=lerp(max_d, min_d, i/n);
		h=(i+1)*dh;
		cylinder(h=h+.1,d=d, $fn=fn);
		translate([-d/2,-1.25*d-.2,-.1]) cube([d,d+.2,h+.3]);
	}
	for(i=[0:n]){
		d=lerp(max_d, min_d, i/n);
		h=(i+1)*dh;
		translate([0,-d/4,(i+.5)*dh]){
			rotate([90,0,0])
				linear_extrude(1,center=true)
				text(text=str(d),size=.7*dh, valign="center", halign="center");
	  }
	}
}