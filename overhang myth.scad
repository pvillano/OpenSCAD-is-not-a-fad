use <platonic_solids.scad>

$fa = .01;
$fs = $preview ? 10 : 2;

//r1=100;
r2=20;
//mega
r1 = 200*sqrt(2);


n=round(2*PI*r1/2/$fs);
translate([0,0,r1+r2*2]) octahedron(r2*2);
difference(){
    for(i=[0:n-1]){
        a1=i/n*180;
        a2=(i+1)/n*180;
        hull(){
        translate([r1*cos(a1), 0, r1*sin(a1)])
            octahedron(r2);
        translate([r1*cos(a2), 0, r1*sin(a2)])
            octahedron(r2);
        }
    }
    translate([0,0,-2*r1])
        cube(r1*4, center=true);
}