sides=10;
n=sides/2;
height=30;
circumradius = 20;
apothem= circumradius * cos(180/n);
side = circumradius * 2 * sin(180/n);
module mirror2(xyz){
  children();
  mirror(xyz) children();
}
module balls(){
  mirror2([0,1,0])
  for(i=[1:n]){
    rotate([0,0,i*360/n]) translate([apothem,side/4,height/2]) sphere(side/4);
  }
}

module boundry(){
  slope=height/(circumradius-apothem);
  h2=apothem*slope+height/2;
  hull(){
    linear_extrude(height=height, slices=1, twist=360/sides, center=true)
    circle(r=20, $fn=n);
    cylinder(r=.01,h=2*h2, center=true,$fn=sides);
  }
}

module main(){
  linear_extrude(height=height, slices=1, twist=360/sides, center=true)
    circle(r=20, $fn=n);
  intersection(){
    union(){
      balls();
      rotate([0,0,180/n])mirror([0,0,1])balls();
    }
    boundry();
  }
}

if(sides%2 !=0){
  text("error");
} else {
  main();
}