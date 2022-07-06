$fa=.01;
$fs=1;
h=100;
w=50;
lh = 1;
ep=.01;
n=h/lh;
PHI = (1+sqrt(5))/2;
k=3;
catmap = function (i) i*(i+1)/2/n*360;
golden = function (i) i*360/PHI;
spiral = function (i) i*k/n*360;

consoleout = function(i) log(i+1)/log(n)*360*4;

candy = catmap;

COLOR = "green";

module mmu(c, alpha=1.0){
	if($preview || c==COLOR)
		color(c, alpha)
		children();
}

module half()
	for(i=[0:n-1])
	translate([0,0,i*lh])
	rotate([0,0,candy(i)])
	intersection()
{
	cylinder(h=lh+ep,d=w);
		translate([0,-w/2,0])
		cube([w/2,w,lh]);
}



mmu("red") half();
mmu("green") rotate([0,0,180]) half();
