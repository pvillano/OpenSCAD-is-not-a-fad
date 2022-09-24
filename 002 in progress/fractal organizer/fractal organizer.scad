use_inches=true;

Length = 5;
Width = 6;
Height = 1;
Wall_Thickness=1.28;
Bottom_Thickness=2;
Maximum_Depth_Ratio=1.0; // prevents holes from getting too deep
Rounding_Radius = 3.0;

module __Customizer_Limit__ () {}
$fa = .01;
$fs = .3;
inch = use_inches ? 25.4 : 1;

module cubette(xyz, delta, center=false){
	// cube but each face is offset inward by delta
  translate([1,1,1]*delta)
		cube(xyz-offset_*[2,2,2], center=center);
}

module round_cube(xyz, r, center=false){
	// cube but edges and corners are rounded
	// preserves outside dimensions.
	// uses a smaller radius if necessary
  min_r = min(r, xyz.x/2-.002,xyz.y/2-.002,xyz.z/2-.002);
  translate(center ? [0,0,0] : .5*xyz) minkowski(){
    sphere(min_r);
    cube(xyz-2*min_r*[1,1,1], center=true);
  }
}

module round_cubette(xyz,r,delta,center=false){
	// cube but each face is offset inward by delta,
	// and edges and corners are rounded
  translate([1,1,1]*delta) round_cube(xyz-delta*[2,2,2], r=r, center=center);
}

// sums a vector by computing the dot product with [1,1,1...]
function sum(x) = x * [for(i=[1:len(x)]) 1];

module fractal_organizer(
	width=Width,
	length=Length,
	height=Height,
	wall_thickness=Wall_Thickness,
	bottom_thickness=Bottom_Thickness,
	maximum_depth_ratio=Maximum_Depth_Ratio,
	rounding_radius=Rounding_Radius
) {

	// fractal_negative produces a box with half-thick walls on the outside
	// we give it less room and shift it half a wall thickness
  negative_length = inch * length - wall_thickness;
  negative_width = inch * width - wall_thickness;
  difference(){
    cube([inch * width, inch * length, inch * height]);
    translate([0.5*wall_thickness, 0.5*wall_thickness, -0.5*wall_thickness+bottom_thickness]) // 
			fractal_negative(
				width=negative_width,
				length=negative_length,
				height=inch * height,
				wall_thickness=wall_thickness,
				maximum_depth_ratio=maximum_depth_ratio,
				rounding_radius=rounding_radius);
  }
}
    
//module fractal_negative(a,outside_ratio,w,h,wall_thickness){
module fractal_negative(width, length, height, wall_thickness, maximum_depth_ratio, rounding_radius){
	// carves a bunch of pockets, each with it's own offset of wall_thickness/2
	// for a total of wall_thickness gap between pockets
	// derivation not available upon request
	outside_ratio = width/length;
  assert(outside_ratio>1);
  pocket_ratio = outside_ratio-1/outside_ratio;
	
	n=20; // todo calculate n explicitly
	for(i=[0:n]){
    //pockets from left to right along top edge
    y1 = outside_ratio^(-2*i) * length;
		x1 = y1*pocket_ratio;
    z1 = min(height,x1*maximum_depth_ratio,y1*maximum_depth_ratio);
    
    dx1 = i==0 ? 0 : pocket_ratio*sum([for(j=[0:i-1]) outside_ratio^(-2*j)]) * length;
    dy1 = length-y1;
    if(min(x1,y1)>$fs)
			translate([dx1,dy1,height-z1])
				round_cubette([x1,y1,z1+rounding_radius], delta=wall_thickness/2,  r=rounding_radius);
    
		
    //pockets from bottom to top along right edge
    x2 = outside_ratio^(-2*i-1) * length;
    y2 = x2*pocket_ratio;
    z2 = min(height, x2*maximum_depth_ratio, y2*maximum_depth_ratio);
    
    dx2 = width-x2;
    dy2 = i==0 ? 0 : pocket_ratio*sum([for(j=[0:i-1]) outside_ratio^(-2*j-1)]) * length;
    if(min(x1,y1)>$fs)
			translate([dx2,dy2,height-z2])
				round_cubette([x2,y2,z2+rounding_radius], delta=wall_thickness/2, r=rounding_radius);
  }
}


fractal_organizer();