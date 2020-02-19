$fa = .01;
$fs = 1;
n = 1000;
r = 50;
thickness = 1.2*r/sqrt(n);
echo("thickness is ", thickness);
phi = (sqrt(5)-1)/2;

difference(){
    union(){
        for(i = [0:n])
            rotate(i*phi*360)
                translate([sqrt(i)*r/sqrt(n),0,])
                    sphere(r=thickness);
        hull(){
            sphere(r=2, $fs=.5);
            translate([0,0,30]) sphere(r=2, $fs=.5);
        }
    }
    cylinder(d=1.75, h=300, center=true, $fs=.3);
}


