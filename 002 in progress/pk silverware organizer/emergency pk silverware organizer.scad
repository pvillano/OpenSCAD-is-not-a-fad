//measurements
in_width = 9.3125;
//design parameters
thin_wall_thickness = 1.28;
n_splits = 12;
height_inch = 2.00;
widths1 = [3,3,3,3];
widths2 = [1,2,4,5];
//constants
inch = 25.4;
//calculated
twt = thin_wall_thickness;
depth = (in_width * inch - 3);
widths = [each widths1, each widths2]*depth/n_splits;
offsets = [0, each cumsum(widths)];
height = height_inch * inch;

function cumsum(values) =  [ for (a=0, b=values[0]; a < len(values); a= a+1, b=b+(values[a]==undef?0:values[a])) b];

echo( cumsum(widths))
for (i=[0:len(widths)-1]){
  width=widths[i];
  offset=offsets[i];
  lwh_outer = [depth, width,height];
  lwh_inner = lwh_outer - 2 * twt* [1, 1, 0];
  translate([0,offset+4*i,0]) difference(){
    cube(lwh_outer);
    translate([twt, twt, twt]) cube(lwh_inner);
  }
}