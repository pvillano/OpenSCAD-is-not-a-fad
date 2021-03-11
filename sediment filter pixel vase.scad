// for #6 filter

$fa = .01;
$fs = $preview ? 5 : 1;

height = 95;

r_max = 62.5;
r_min = .5;
rect_l_min = 59;

cube_size = 3;

function mix(x, y, a) = (x*(1-a) + a*y);
function round_to(x, r) = round(x/r)*r;
bounds_r = round_to(r_max, cube_size) + cube_size;
function sqr(x) = x*x;

for (x = [-bounds_r:cube_size:bounds_r]){
    for( y = [-bounds_r:cube_size:bounds_r]){
        for( z = [cube_size/2:cube_size:round_to(height, cube_size) + cube_size/2]){
            r=norm([x,y]);
            x2 = cos(atan2(y,x)+45)*r;
            y2 = sin(atan2(y,x)+45)*r;
            if(
                (abs(x2) < mix(rect_l_min/2,0,z/height) && abs(y2) <= mix(r_min, r_max, z/height))
                || (sqr(x2+mix(rect_l_min/2, 0, z/height)) + sqr(y2) <= sqr(mix(r_min, r_max, z/height)))
                || (sqr(x2-mix(rect_l_min/2, 0, z/height)) + sqr(y2) <= sqr(mix(r_min, r_max, z/height)))
            ){
                translate([x,y,z]) cube(cube_size, center=true);
            }
        }
    }
}