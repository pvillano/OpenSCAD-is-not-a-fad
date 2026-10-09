$fa=.01;
$fs=3;

motor_rpm = 3;
max_print_area = 200;


module motor(){
  mirror([0,0,1]) cylinder(d=49, h=20.5);
  translate([0,7,0]) cylinder(h=16,d=6);
}

#motor();

cylinder(d=max_print_area);
color("red") cylinder(d=5,h=10);