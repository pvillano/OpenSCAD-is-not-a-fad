inch = 25.4;

b_num = 3;
b_denom = 2;
twt=.4;
h=3;
w=inch*b_denom;
n=15;

b=b_num/b_denom;
assert(b>1);
a=b-1/b;

module cubette(xyz, twt=twt){
  translate([1,1,1]*twt/2) cube(xyz-twt*[1,1,1]);
}

function sum(x) = x * [for(i=[1:len(x)]) 1];

mirror([0,0,1]) color("black") cubette([b*w,w,h]);

translate([0,0,0])   cubette([a*w,w,h]);
//translate([a*w,0,0]) cubette([(b-a)*w,(b-a)*a*w,h]);
translate([a*w,0,0]) cubette([1/b*w,a/b*w,h]);
//translate([a*w,a/b*w,0]) cubette([(1-a/b)*a*w,(1-a/b)*w,h]);
translate([a*w,a/b*w,0]) cubette([a*1/b^2*w,1/b^2*w,h]);

for(i=[0:n/2-1]){
  x1=w*a*b^(-2*i);
  y1=w*b^(-2*i);
  dx1= i==0 ? 0 : w*a*sum([for(j=[0:i-1]) b^(-2*j)]);
  dy1= w-y1;
  translate([dx1,dy1,0]) cubette([x1,y1,h]);
  
  x2=w*b^(-2*i-1);
  y2=w*a*b^(-2*i-1);
  dx2=w*b-x2;
  dy2= i==0 ? 0 : w*a*sum([for(j=[0:i-1]) b^(-2*j-1)]);
  translate([dx2,dy2,0]) cubette([x2,y2,h]);
  
}
