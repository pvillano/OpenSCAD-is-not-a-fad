$fa=.01;;
$fs=.1;

r=30;
h0 = .2;
h1 = 1.2;
dh = .1;
n=ceil((h1-h0)/dh);
spacing=5;
emboss=dh;

module pick(r,h) linear_extrude(h) intersection(){
  circle(r=r);
	translate([r,0,0]) circle(r=r);
	rotate([0,0,60]) translate([r,0,0]) circle(r=r);
}

m=ceil(sqrt(n));
for(x=[0:m-1],y=[0:m-1]){
		dx=r+spacing;
		dh=(x+m*y)*dh+h0;
		translate([dx*x,dx*y,0]) difference(){
			pick(r,dh);
			translate([r/2,0,dh-emboss]) linear_extrude(height=2*emboss) text(str(dh), halign="center");
		}
}