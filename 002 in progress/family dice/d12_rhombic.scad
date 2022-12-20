$fa=.01; $fs=.5;

current_color = "ALL";
font_size = 10;
radius = 30*sqrt(2);
r = radius;
r2 = radius/sqrt(2);
bg = .7;
letter_depth = r2*bg;
thicker=2;
thinner=1.5;

module letter(l) {
  translate([0,0,thinner-thicker])
  linear_extrude(height = letter_depth) {
    text(l, size = font_size, halign = "center",
      valign = "center", $fn = 16);
  }
}


/*
  Points spiral down from the top, as do faces.
*/
module octahedron(r){
  scale(r) polyhedron(
    points=[
      [ 0,  0,  1],
      [ 1,  0,  0],
      [ 0,  1,  0],
      [-1,  0,  0],
      [ 0, -1,  0],
      [ 0,  0, -1],
    ],
    faces=[
      [0, 1, 2],
      [0, 2, 3],
      [0, 3, 4],
      [0, 4, 1],
      [5, 2, 1],
      [5, 3, 2],
      [5, 4, 3],
      [5, 1, 4],
    ]
  );
}

module rhombic_dodecahedron(r){
  hull(){
    cube(size=r, center=true);
    octahedron(r);
  };
}


rotate([45,atan(1/sqrt(2)),0]) 
difference(){
  rhombic_dodecahedron(r);
  rhombic_dodecahedron(r-thicker*sqrt(2));
  rotate([atan(1/sqrt(2)),-45,-90]) cylinder(h=100,d=5, center=true);
  union(){
    rotate([0, 45,0]) translate([0,0,r2]) letter("Tony");
    rotate([0,135,0]) translate([0,0,r2]) letter("Suze");
    rotate([0,225,0]) translate([0,0,r2]) letter("Erik");
    rotate([0,-45,0]) translate([0,0,r2]) letter("Tate");

    rotate([ 45,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("Liz");
    rotate([135,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("Michael");
    rotate([225,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("Marisa");
    rotate([-45,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("Shama");

    rotate([0,0, 45]) rotate([90,0,0]) translate([0,0,r2]) letter("Rocky");
    rotate([0,0,135]) rotate([90,0,0]) translate([0,0,r2]) letter("Hind");
    rotate([0,0,225]) rotate([90,0,0]) translate([0,0,r2]) letter("Sylvia");
    rotate([0,0,-45]) rotate([90,0,0]) translate([0,0,r2]) letter("Mike");
  }
}
