$fa = .01;
$fs = 1;
n = 200;
r = 25;
thickness = 1.2*r/sqrt(n);
spindle_r = 1.75/2 + .15*3;
echo("thickness is ", thickness, spindle_r);
phi = (sqrt(5)-1)/2;

difference(){
    union(){
        for(i = [0:n])
            rotate(i*phi*360)
                translate([sqrt(i)*r/sqrt(n),0,])
                    sphere(r=thickness);
        hull(){
            sphere(r=spindle_r, $fs=.5);
            translate([0,0,r*.7])
                sphere(r=spindle_r, $fs=.5);
        }
    }
    cylinder(d=1.75, h=300, center=true, $fs=.3);
}


