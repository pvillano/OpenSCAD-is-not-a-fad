Name = "Your Name";
Fit_Width = true;
Layer = "All"; // ["All", "White", "Blue", "Gold", "Clip", "Hanger"]

module __Customizer_Limit__() {}
slop = .2;
Width = 210;
BaseThickness = 1.4;
LabelThickness = .8;
Height = 55;
Margin = 7;
Font = "Verdana";
Widening = 1;
Layers = 2;

ep = .01;
$fa = .01;
$fs = .5;


module label(layer = 1)
translate([-Width / 2 + Margin, 0, (layer - 1) * LabelThickness])
  linear_extrude(LabelThickness) {
    offset(r = (Layers - layer) * Widening)
      resize([Width - 2 * Margin - 2 * LabelThickness, 0], auto = true) {
        h = Height - 2 * Margin;

        llCorner = [1.8, 1.8];
        urCorner = [68.8, 61.8];
        center = (llCorner + urCorner) / 2;
        dims = urCorner - llCorner;
        scaleFactor = h / dims[1];
        logoWidth = dims[0] * scaleFactor;
        scale(scaleFactor)
          translate([-llCorner[0], -center[1]])
            import("logo_blue.svg");
        translate([logoWidth + h * .5, 0])
          text(Name, size = h, font = Font, halign = "left", valign = "center");
      }

  }

module base() translate([0, 0, -BaseThickness]) {
  linear_extrude(BaseThickness) square([Width, Height], center = true);
}

module trangle() {
  difference() {
    r = Height / sqrt(3);
    circle(r = r);
    for (a = [0, 120, 240]) {
      rotate(a) translate([2 * r * (2 / sqrt(3)), 0]) circle(r = 2 * r);
    }
  }
}

module clip() {
  linear_extrude(10) scale([1,.95]){
    translate([.29 * Height, 0, 0])difference() {
      offset(r = BaseThickness) square([BaseThickness, Height], center = true);
      offset(r = slop) square([BaseThickness, Height], center = true);
      square([4 * BaseThickness, Height - 4 * BaseThickness], center = true);
    }

    difference() {
      offset(r = BaseThickness) trangle();
      trangle();
      translate([Height, 0]) circle(r = Height, $fn = 6);
      translate([.29 * Height, 0, 0]) offset(r = slop) square([BaseThickness, Height], center = true);
    }
  }
}


if (Layer == "All" || Layer == "White") color("white") base();

if (Layer == "All" || Layer == "Blue") color([12, 35, 64] / 200) {
  label(2);
}

if (Layer == "All" || Layer == "Gold") color([201, 151, 0] / 255) {
  label(1);
}

if (Layer == "All") color("white") {
  translate([-Width / 3, 1.5 * Height]) clip();
  translate([Width / 3, 1.5 * Height]) clip();
}

if (Layer == "Clip")
  color("white")
  for(i=[-2:2])
  translate([.75*i*Height, 0,0])
{
  clip();
  r1 = Height / sqrt(3);
  r2 = 7;
  scale([1,.95]) for (a = [0, 120, 240])rotate([0, 0, a + 60]) {
    translate([r1 + r2 + .8 + BaseThickness, 0, 0]) cylinder(r = r2, h = .4);
    #translate([r1 + .3, -.4, 0]) cube([r2, 1.2, .2]);
  }
}

FeltThickness = 13; //todo

if (Layer == "Hanger") linear_extrude(10)
{
    translate([BaseThickness, Height/2+BaseThickness/2, 0]) difference() {
      offset(r = BaseThickness) square([BaseThickness, Height], center = true);
      offset(r = slop) square([BaseThickness, Height], center = true);
      square([4 * BaseThickness, Height - 4 * BaseThickness], center = true);
    }
  clipLength = 2*FeltThickness;
  difference(){
    translate([0,Height/2+BaseThickness/2,0]) circle(Height/2+BaseThickness);
    translate([0,Height/2+BaseThickness/2,0]) circle(Height/2);
    translate([0,-BaseThickness/2])square(Height+2*BaseThickness);
  }
  difference(){
    translate([0,Height/2-FeltThickness-BaseThickness/2,0]) circle(Height/2+BaseThickness+BaseThickness+FeltThickness);
    translate([0,Height/2-FeltThickness-BaseThickness/2,0]) circle(Height/2+BaseThickness+FeltThickness);
    square(Height+2*BaseThickness);
    rotate(-90) square(Height+2*BaseThickness);
    rotate(180) square([FeltThickness+BaseThickness,clipLength+20]);
  }
  translate([-BaseThickness/2,-BaseThickness/2])rotate(180)difference(){
    offset(r=BaseThickness) square([FeltThickness,clipLength]);
    square([FeltThickness,clipLength+BaseThickness]);
    translate([FeltThickness/2,0]) square([7,BaseThickness*2], center=true);
  }
}
