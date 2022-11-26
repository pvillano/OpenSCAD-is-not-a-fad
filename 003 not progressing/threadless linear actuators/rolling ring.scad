$fa=0.1;
$fs=.31;

rod_diameter = 6;
bearing_od = 22;
bearing_id = 8;
bearing_width = 7;
thread_pitch = 3;
rod_length=300;

//module rod(diameter=rod_diameter, length=rod_length)
//nvm that's just a cylinder

module bearing(od=bearing_od, id=bearing_id, width=bearing_width,center=false){
    difference(){
        cylinder(d=od,h=width, center=center);
        translate([0,0,(center? 0: -.1)]) cylinder(d=id,h=width+.2, center=center);
    }
}

//bearing();
module demo() intersection(){
    epsilon=.18;
    twist = atan2(thread_pitch, rod_diameter*PI);
    //for(azimuth=[0,120,240]){
    for(azimuth=[0]){
        rotate([0,0,azimuth])
            translate([rod_diameter/2-bearing_id/2+epsilon,0,0])
            rotate([twist,0,0])
            bearing(center=true);
    }
    cylinder(d=rod_diameter, h=rod_length, center=true);
}

/*
we're interested in finding the relation of the following variables:

* h: height of the bearing
* id: id of the bearing
* p: twist/thread pitch
* d: diameter of the rod
* c: distance from the center of the rod

we intend to solve for ?

multiple coordinate systems include cylindrical, parameterized, cartesian...
we need to find a point in space that lies on the edge of the bearing
and the surface of the rod.

let a= atan2(p,pi*d) //a is small
d = 2*min_r translate([c,0,0]) rotate([a,0,0]) translate([0,0,h/2]) circle(d=id)
(1) x(t)=id/2*cos(t), y=id/2*sin(t), z=0, t=[0,2*pi]
(2) x(t)=id/2*cos(t), y=id/2*sin(t), z=h/2, t=[0,2*pi]
(3) y(t) = cos(a)*old_y-sin(a)*old_z
(3) x(t)=id/2*cos(t), y=id/2*sin(t)*cos(a)-sin(a)*h/2, z=who cares, t=[0,2*pi]
(4) x(t)=id/2*cos(t)+c, y=id/2*sin(t)*cos(a)-sin(a)*h/2, t=[0,2*pi]
(5) maximize r^2 = xx+yy
(5) maximize (id/2*cos(t)+c)^2 + (id/2*sin(t)*cos(a)-sin(a)*h/2)^2
(6) let x = id for wolfram alpha
(6) zeros of (-x*sin(t)*(c+1/2*x*cos(t))) + (1/2*x*cos(a)*cos(t)*(x*cos(a)*sin(t) - h*sin(a)))
(6) ...
(6) just use newton's method idk
(7) let u = cos(t), sin(t) = sin(invcos(u)) = sqrt(1-u^2)
(7) zeros of (-x*sqrt(1-u^2)*(c+1/2*x*u)) + (1/2*x*cos(a)*u*(x*cos(a)*sqrt(1-u^2) - h*sin(a)))
(7) ...
(7) u = c/(x (cos^2(a) - 1)) - 1/2 sqrt(((-1728 x^2 (cos^2(a) - 1)^2 c^4 ... // continues for 7000 characters
    d = (id/2*u+c)^2 + (id/2*sqrt(1-u^2)*cos(a)-sin(a)*h/2)^2
(8) no but really just use newton's method
 */

demo();