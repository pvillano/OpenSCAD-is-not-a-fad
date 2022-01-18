$fa = .01;
$fs = $preview ? 10 : .3;

od=45.6-.4;
id=40.8+.2;
h=43-1;


difference(){
    cylinder(h=h,d=od,center=true);
    cylinder(h=h+.1,d=id,center=true);
}