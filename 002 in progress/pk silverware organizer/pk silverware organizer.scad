//measurements
in_width = 9.3125;
in_fork = 8;
in_soup = 8;
in_cereal = 7;
in_chopstick = 9;
in_chop = 7.5;
in_head_l = 2.5;
in_head_w = 1.5;
//design parameters
thin_wall_thickness = 1.6;
sections = 8;
//constants
inch = 25.4;
//calculated
twt = thin_wall_thickness;
width = in_width * inch;
head_w = in_head_w * inch;

lwh_outer = [width,width,2.5*inch];
lwh_inner = lwh_outer - 2*twt*[1,1,0];

module maybe_mirror(xyz, yes){
  if(yes){
    mirror(xyz) children();
  } else {
    children();
  }
}


difference(){
  translate(-[twt,twt,twt]) cube(lwh_outer);
  cube(lwh_inner);
}
%translate([0,0,-2])cube([256,256,1]);

%for(i=[1:sections]){
  len_barrier = lwh_inner[1]/4;
    translate([(i-.5)*lwh_inner[0]/sections,lwh_inner[1]/2,0])
    maybe_mirror([0,1,0],(i%2)==0)
    translate([0,-lwh_inner[1]/3,0])
    #cube(head_w, center=true);
}

for(i=[1:sections]){
  len_barrier = lwh_inner[1]/4;

    translate([(i-.5)*lwh_inner[0]/sections,lwh_inner[1]/2,0])
    maybe_mirror([0,1,0],(i%2))
    translate([0,-lwh_inner[1]/2,0])
    cube([twt,len_barrier,lwh_inner[2]]);
}
for(i=[1:sections]){
  len_barrier = lwh_inner[1]/2;

    translate([i*lwh_inner[0]/sections,lwh_inner[1]/2,lwh_inner[2]/2])
    cube([twt,len_barrier,lwh_inner[2]], center=true);
}