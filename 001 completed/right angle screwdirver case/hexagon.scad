//measured
bitDiameterInches = .251;
shankLength = 20;
//designed
twt = 1.2;
//constant
inch = 25.4;
//calculated
bitDiameter = bitDiameterInches * inch;
bitCircumDiameter = bitDiameter / cos(30);

module x() {
  circle(d = bitCircumDiameter, $fn = 6);
  for (i = [0:5]) {
    rotate([0, 0, i / 6 * 360]) translate([0, bitDiameter + twt, 0]) circle(d = bitCircumDiameter, $fn = 6);
  }
}
linear_extrude(10) difference() {
  offset(delta = twt) x();
  x();
}