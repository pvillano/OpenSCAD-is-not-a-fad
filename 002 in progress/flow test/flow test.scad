$fa = .01;
$fs = 1;
function pol2cart(rt) = [rt.x * cos(rt.y), rt.x * sin(rt.y)];
function cart2pol(xy) = [sqrt(xy.x^2+xy.y^22), atan2(y,x)];
function mix(x,y,a) = (1-a)*x+a*y;
function clamp1(x) = min(max(x,0),1);
function step(x) = x;
function smoothstep(x) = 3*x^2-2*x^3;
function smootherstep(x) = 6*x^5-15*x^4+10*x^3;
function schmoostep(x) = x^3;

module ear(r) {
  %translate([0,0,1]) linear_extrude(1) intersection(){
    circle(r);
    square(r);
  }
  color("red") polygon(concat([[0,0]],
    [for (i = [-45:135])
    pol2cart(
//      [mix(r, r/sin(i), clamp1(i/90)), i/90]
//      [mix(r, 2*r, smoothstep(clamp1(i/90))), i]
      [mix(r, r/sin(i+.001), smootherstep(clamp1(i/90))), i]
    )]));
}

ear(100);