slot_width = 4;
slot_height = 15.9;
// make sure this is twice the distance from the thumbwheel to the center of gravity
slot_length = 15;
pyramid_height = 49+3;
//distance above the ground the bar/main scale of the calipers should float above the ground
slot_clearance=10;

wall_thickness=1.89;

//extra space for
slip_allowance=.1;
h1=pyramid_height - slot_clearance;
h2 = pyramid_height;
h3=pyramid_height + slot_height;


w2 = max(3*slot_width, slot_length);
w1=h1*2+w2;


module all_in_one() difference(){
  union(){
    translate([-w2/2,-w2/2,0]) cube([w2, w2, h3]);
    hull(){
      translate([-w1/2,-w1/2,0]) cube([w1,w1, .1]);
      translate([-w2/2,-w2/2,0]) cube([w2, w2, h1]);
    }
  }
  translate([-slot_width/2,-w2/2-.1,h2]) cube([slot_width, w2+.2,slot_height+.1]); 
  translate([0,0,h3+.2*w2]) rotate([90,0,0]) rotate([0,0,45]) cube(w2+.2, center=true);
}

module body() difference(){
  union(){
    hull(){
      translate([-w1/2,-w1/2,0]) cube([w1,w1, .1]);
      translate([-w2/2,-w2/2,0]) cube([w2, w2, h1]);
    }
  }
  
  translate([-(w2+slip_allowance)/2,-(w2+slip_allowance)/2,wall_thickness]) cube([w2+slip_allowance, w2+slip_allowance, h3]);
  
  w4=w1-2*wall_thickness-2*sqrt(2)*wall_thickness;
  hull(){
    translate([-w4/2,-w4/2,wall_thickness]) cube([w4,w4,.01]);
    translate([0,0,wall_thickness]) cube([.001,.001,w4/2]);
  }
}

module insert() difference(){
  union(){
    translate([-w2/2,-w2/2,wall_thickness]) cube([w2, w2, h3-wall_thickness]);
  }
  translate([-slot_width/2,-w2/2-.1,h2]) cube([slot_width, w2+.2,slot_height+.1]); 
  translate([0,0,h3+.2*w2]) rotate([90,0,0]) rotate([0,0,45]) cube(w2+.2, center=true);
}

insert();
%difference(){
  body();
  if($preview) translate([0,0,-1]) cube(999);
}

!all_in_one();