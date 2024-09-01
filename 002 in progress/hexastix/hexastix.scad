widthAcrossFlats = 6.95;
sideLength = 4;
height=0;
thickness=1.2;

pencilsAcross = sideLength * 4 - 3;
circumscribedDiameter = widthAcrossFlats * 2 / sqrt(3);

module borderize(t){
  difference(){
    offset(t) children();
    children();
  }
}


mat = [
    [cos(0), cos(120), cos(240)],
    [sin(0), sin(120), sin(240)]
  ];
dx = sideLength - 1;
linear_extrude(height ? height : widthAcrossFlats) borderize(thickness){
  for (a = [0:dx], b = [0:dx], c = [0:dx]) {
    #translate(mat * [a, b, c] * circumscribedDiameter * 2) circle(d = circumscribedDiameter, $fn = 6);
  }
  circle(d=circumscribedDiameter*(sideLength*4-4), $fn=6);
}
