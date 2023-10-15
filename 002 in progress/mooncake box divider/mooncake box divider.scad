width = 205;
thickness = 1.28;
height = 54;

// I probably could have done this in 2d but whatever
// now i have to do this in 2d so i can chamfer whee
unit = (width - thickness) / 5;


module rectangle() {
  difference() {
    offset(delta = thickness / 2) square([1, 2] * unit, center = true);
    offset(delta = - thickness / 2) square([1, 2] * unit, center = true);
  }
}
module shadow() {
  for (th = [0, 90, 180, 270]) {
    rotate(th) {
      translate([1, .5] * unit) rectangle();
      translate([2, - .5] * unit) rectangle();
    }
  }
}

module chube(d, t){
    hull(){
       cube([d,    d-2*t,d-2*t], center=true);
       cube([d-2*t,d,    d-2*t], center=true);
       cube([d-2*t,d-2*t,d    ], center=true);
    }
}

module main(){
  render() intersection(){
    linear_extrude(height)shadow();
    translate([0,0,width/2]) chube(width, 5);
  }
}
if($preview){
  main();
} else {
  //optimal print orientation
  rotate(atan(2)) mirror([0,0,1]) main();
}
