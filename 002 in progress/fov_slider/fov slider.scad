diagonal = 27;
resolution = [1920, 1080];
fov = 103; //[40:120]


number_of_slats=5;
w=60;
d=15;
h=20;
twt=.5;

module __Customizer_Limit__() {}
/*
version 0: place in center of screen
*/

display_depth=1;

inch = 25.4;

diagonal_resolution = sqrt(resolution.x^2 + resolution.y^2);

display_width = diagonal * inch * resolution.x / diagonal_resolution;
display_height = diagonal * inch * resolution.y / diagonal_resolution;
display_distance = display_width/2 * 1/tan(fov/2);

module mirror2(xyz){
  children();
  mirror(xyz) children();
}

module sanity_check(){
  cube([display_width, display_depth, display_height], center=true);
  color("red") rotate([90,0,0]) cylinder(h=.2, d=diagonal*inch, center=true);
}

module context(){
  cube([display_width, display_depth, display_height], center=true);
  cube([w,d,h], center=true);
  mirror2([1,0,0]){
    translate([32,-display_distance,0]) sphere(d=inch);
    translate([0,-display_distance,0])
      rotate([0,0,-fov/2])
      cube([1, display_distance*2,10]);
  }
}


module slats(){
  half_angle = atan2(w/2, display_distance);
  intersection(){
    translate([0,-d/2,0]) cube([999,d,999], center=true);
    for(i=[0:number_of_slats-1]){
      t=i/(number_of_slats-1);
      theta=-half_angle + 2*half_angle*t;
      translate([0,-display_distance,0])
        rotate([0,0,theta])
        translate([-twt/2,0,-h/2])
        cube([twt, display_distance*2,h]);
    }
  }
}

module main(){
  slats();
  
  mirror2([0,0,1])
    translate([0,0,-h/2])
    linear_extrude(twt)
    hull()
    projection()
    slats();
  
}

//%context();
main();








































