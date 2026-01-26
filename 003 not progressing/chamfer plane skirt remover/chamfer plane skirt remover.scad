$fa=.01;
$fs=1;

width = 64;
length = 30;
height = 110;
twt=4;

bladeWidth1 = 60;
bladeWidth2 = 31;
bladeHeight = 19;
bladeThickness = .6;

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}
module rotate2(xyz,n=2){
  for(i=[0:n-1])
    rotate(360*i/n,xyz)
      children();
}

module sequentialHull(){
    if($children==1){
      children();
    } else if($children>0) for (i = [0: $children-2])
        hull(){
            children(i);
            children(i+1);
        }
}

module squentialHull(){
  groups=[[1,2,3,4],[3,4,5,6],[5,6,7,8]];
  for(i=[0:len(groups)-1]){
  hull()
    for(j=[0:3]){
      children(groups[i][j]);
    }
  }
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
  big=150;
  ds=[.5,1,2,3];
  difference(){
    union(){
     translate([0,0,height/2])rotate([0,90,0]) difference(){
       cylinder(d=width,h=width,center=true);
       cylinder(d=width-2*twt,h=width+2,center=true);
     }
      cube([width,width,height], center=true);
      intersection(){
        translate([0,0,height/2])rotate([0,90,0])  cylinder(d=width,h=width,center=true);
        cube([width,width,height+20], center=true);
      }
    }
    //blade gap
    //rotate([90,0,0]) blade();
    linear_extrude(bladeHeight)square([width+2,bladeThickness], center=true);
    translate([0,0,1])rotate([0,90,0]) cylinder(d=2,h=width+2, center=true);

    //locking mechanism
    rotate2([0,0,1]) translate([0,0,bladeHeight])#union(){
      translate([0,bladeThickness/2,0])cube([width/2+2,bladeThickness,15]);
      translate([0,-bladeThickness/2,-bladeThickness/2]) cube([width/2+2,bladeThickness*2,bladeThickness]);
      translate([0,0,-bladeThickness/2])linear_extrude(15) square([bladeThickness,bladeThickness*3], center=true);
    }

    n=4;
    //channels
    for(i=[-1:n]) {
      translate([-bladeWidth1 / 2 + bladeWidth1 * (i+.5)/n, 0, 0])
        rotate([-25, 0, 0])
          translate([0, -i, 0])
            rotate(45)
              translate([0, 0, -big / 2])
                cube(big);
      translate([-bladeWidth1 / 2 + bladeWidth1 * (i+.5)/n, 0, 0])
        rotate([25, 0, 0])
          translate([0, i+.5, 0])
            rotate(45+180)
              translate([0, 0, -big / 2])
                cube(big);
    }
    //side grips
    translate([0,0,height/2]) rotate([0,90,0]) linear_extrude(width+.2, center=true) minkowski(){
      ddd=width-2*twt;
      hull(){

      intersection(){
        circle(d=ddd);
        translate([-20,0]) circle(d=ddd);
      }
        translate([32,0]) square([1,12], center=true);
      }
    }
  }
}
main();
