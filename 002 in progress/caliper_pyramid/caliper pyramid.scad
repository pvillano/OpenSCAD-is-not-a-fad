caliper_canyon_width = 3.5;
caliper_canyon_height = 15.9;
caliper_canyon_length = 15;
caliper_pyramid_height = 49+3;
canyon_clearance=10;

ccw_bodge=.4;

twt=1.89;
slop=.1;
h1=caliper_pyramid_height - canyon_clearance;
h2 = caliper_pyramid_height;
h3=caliper_pyramid_height + caliper_canyon_height;


w2 = max(3*caliper_canyon_width, caliper_canyon_length);
w1=h1*2+w2;


module onepiece()difference(){
  union(){
    translate([-w2/2,-w2/2,0]) cube([w2, w2, h3]);
    hull(){
      translate([-w1/2,-w1/2,0]) cube([w1,w1, .1]);
      translate([-w2/2,-w2/2,0]) cube([w2, w2, h1]);
    }
  }
  translate([-caliper_canyon_width/2,-w2/2-.1,h2]) cube([caliper_canyon_width, w2+.2,caliper_canyon_height+.1]); 
  translate([0,0,h3+.2*w2]) rotate([90,0,0]) rotate([0,0,45]) cube(w2+.2, center=true);
}

module mainpart() difference(){
  union(){
    hull(){
      translate([-w1/2,-w1/2,0]) cube([w1,w1, .1]);
      translate([-w2/2,-w2/2,0]) cube([w2, w2, h1]);
    }
  }
  
  translate([-(w2+slop)/2,-(w2+slop)/2,twt]) cube([w2+slop, w2+slop, h3]);
  
  w4=w1-2*twt-2*sqrt(2)*twt;
  hull(){
    translate([-w4/2,-w4/2,twt]) cube([w4,w4,.01]);
    translate([0,0,twt]) cube([.001,.001,w4/2]);
  }
}

module insert() difference(){
  union(){
    translate([-w2/2,-w2/2,twt]) cube([w2, w2, h3-twt]);
  }
	ccw2 = caliper_canyon_width + ccw_bodge;
  translate([-ccw2/2,-w2/2-.1,h2]) cube([ccw2, w2+.2,caliper_canyon_height+.1]); 
  translate([0,0,h3+.2*w2]) rotate([90,0,0]) rotate([0,0,45]) cube(w2+.2, center=true);
}

insert();
%difference(){
  mainpart();
  if($preview) translate([0,0,-1]) cube(999);
}