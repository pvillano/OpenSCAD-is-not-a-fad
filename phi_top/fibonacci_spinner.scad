$fa = .01;
$fs = $preview ? 1 :.3;
n = 1000;
r = 50;
phi = (sqrt(5)-1)/2;

module cone(){
    
}
difference(){
    translate([0,0,-3])cylinder(r=r, h=3);
    for(i = [0:n+100]) rotate(i*phi*360) translate([sqrt(i)*r/sqrt(n),0,]) cube(size=1.2*r/sqrt(n), center=true);
    translate([0,0,-3]) linear_extrude(height=30, scale=.5) circle(d=4, $fn=6);
}

