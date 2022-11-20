magnet_length=19;
magnet_width=9.5;
magnet_height=4.6;
wall_thickness=1.28;
slop=.2;
throat=12;
n_steps=3;
h_step=2;

l=magnet_length+slop;
w=magnet_width+slop;
h=magnet_height+slop;


h_bod = 4*wall_thickness+2*h+throat;

difference(){
    translate(-wall_thickness*[2,1,1])
        cube([l+4*wall_thickness,w+2*wall_thickness, h_bod]);
    //magnets
    cube([l,w,h]);
    translate([0,0,h+throat+2*wall_thickness]) cube([l,w,h]);
    //throat
    translate([0,-wall_thickness-.1,h+wall_thickness]) cube([l,99,throat]);
    //cutaway
    if($preview) translate([0,w/2-50,0]) cube(100, center=true);
}

dx=(l/2+wall_thickness)/n_steps;

for(i=[0:n_steps-1]){
    x=l/2+i*dx;
    z=wall_thickness+(i+1)*h_step;
    translate([x,-wall_thickness,-z])
        cube([l+2*wall_thickness-x,w+2*wall_thickness,z]);
}