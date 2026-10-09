

module face(){
  color("#644404") render() difference(){
    translate([-70.5,0,-78.5]) rotate([90,0,0]){
      linear_extrude(57) import("eyes.svg");
      linear_extrude(63) import("mouth.svg");
      linear_extrude(57) import("brows.svg");
    }
    sphere(63*1.02, $fn=9);
  }
//  color("#f3930c") render() difference(){
//    translate([-70.5,0,-78.5]) rotate([90,0,0]){
//      t=15;
//      translate([0,0,60-t]) linear_extrude(t) import("hand.svg");
//    }
//    sphere(63*1.02, $fn=9);
//  }
}

module version_a(){
  h0=60;
  for(r=[0,120,240]) rotate([0,0,r]) face();
  color("#fbcb4b") difference(){
    sphere(63*1.02 -.3 /*slop*/, $fn=9);
    translate([0,0,-63*1.02 -.3-.1]) cylinder(d=10,h=20, $fs=.3);

  }
}

face();