width = 60;
length = 30;
height = 80;

bladeWidth1 = 60;
bladeWidth2 = 31;
bladeHeight = 19;
bladeThickness = .6;

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}

module blade() {
  linear_extrude(.6, center = true) {
    polygon([
        [-bladeWidth1 / 2, 0],
        [bladeWidth1 / 2, 0],
        [bladeWidth2 / 2, bladeHeight],
        [-bladeWidth2 / 2, bladeHeight]
      ]);
  }
}

module main(){
  %rotate([90,0,0]) blade();
  big=100;
  ds=[.5,1,2,3];
  difference(){
    cube([width,width,height], center=true);
    //blade gap
    rotate([90,0,0]) blade();
    n=3;
    for(i=[-1:n]) {
      translate([-bladeWidth1 / 2 + bladeWidth1 * (i+.5)/n, 0, 0])
        rotate([-25*(-1)^i, 0, 0])
          translate([0, -i*(-1)^i, 0])
            rotate(45+180*i)
              translate([0, 0, -big / 2])
                cube(big);
    }
  }
}
main();
