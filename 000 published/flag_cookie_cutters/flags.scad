
$fa = .01;
$fs = $preview ? 1 : .1;

//width
w = 80;
h = w * 2 /3;
cookie_thickness=1/4*25.4;
d2 = cookie_thickness;
thickness = 1.67;  // 4 lines at .2mm layer height
thickness2 = 3.30; // 8 lines at .2mm layer height


//reused for all flags
module border(){
    translate([0,0,-cookie_thickness/4]) borderize(){
        cube([w, h, cookie_thickness*1.5], center=true);
    }
    for(i=[-1,1]){
        hull(){
            translate([-w/2*i,-h/2,0])cylinder(h=d2/2, d=thickness2);
            translate([w/2*i,h/2,0]) cylinder(h=d2/2, d=thickness2);
        }
    }
}

// from https://gist.github.com/anoved/9622826
module Star(points, outer, inner) {
	
	// polar to cartesian: radius/angle to x/y
	function x(r, a) = r * cos(a);
	function y(r, a) = r * sin(a);
	
	// angular width of each pie slice of the star
	increment = 360/points;
	
	union() {
		for (p = [0 : points-1]) {
			
			// outer is outer point p
			// inner is inner point following p
			// next is next outer point following p

			x_outer = x(outer, increment * p);
            y_outer = y(outer, increment * p);
            x_inner = x(inner, (increment * p) + (increment/2));
            y_inner = y(inner, (increment * p) + (increment/2));
            x_next  = x(outer, increment * (p+1));
            y_next  = y(outer, increment * (p+1));
            polygon(points = [[x_outer, y_outer], [x_inner, y_inner], [x_next, y_next], [0, 0]], paths  = [[0, 1, 2, 3]]);
		}
	}
}


module pentagram(outer) {
    inner = outer*sqrt(3.5-1.5*sqrt(5));
    Star(5,outer, inner);
}

//korea bars
module bars(breaks = [0,0,0]){
    one = w/3;
    dy = one * (1/3-1/12)/2;
    twelth = 2.08; // custom for whatever
    rotate([0,0,-90]) translate([0,one*(1/2+1/4+1/6),0]){
        translate([0,-dy,0]) difference() {
            cube([one/2,twelth,d2], center=true);
            if(breaks[0])
                cube([one/24,one/6,d2+.1], center=true);
        }
        translate([0,0,0]) difference() {
            cube([one/2,twelth,d2], center=true);
            if(breaks[1])
                cube([one/24,one/6,d2+.1], center=true);
        }
        translate([0,dy,0]) difference() {
            cube([one/2,twelth,d2], center=true);
            if(breaks[2])
                cube([one/24,one/6,d2+.1], center=true);
        }
    }
}


module tadpole(){
    one = w/3;
    difference(){
        union(){
            translate([one/4,0,0])
                cylinder(h=d2,r=one/4, center=true);
            difference(){
                cylinder(h=d2,r=one/2, center=true);
                translate([0,one/2,0]) cube([one,one,d2+.1], center=true);
            }
        }
        translate([-one/4,0,0])
            cylinder(h=d2+.1,r=one/4, center=true);
    }
}


//italy
translate([-w*1.5,0,0]){
    border();
    translate([-w/6,0,0]) cube([thickness,h,d2], center=true);
    translate([w/6,0,0]) cube([thickness,h,d2], center=true);
}


//morocco
translate([0,0,0]){
    border();
    linear_extrude(height=d2, center=true){
        rotate([0,0,90]) pentagram(10);
    }
}


//korea
translate([w*1.5,0,0]){
    border();
    
    difference(){
        cylinder(d=w/3+thickness, h=d2, center=true);
        cylinder(d=w/3-thickness, h=d2+thickness/2, center=true);
    }
    
    rotate(0) tadpole();
    
    //atan2 is y,x
    rotate([0,0,atan2(2,3)]) bars([1,0,1]);
    rotate([0,0,atan2(2,-3)]) bars([0,0,0]);
    rotate([0,0,atan2(-2,-3)]) bars([0,1,0]);
    rotate([0,0,atan2(-2,3)]) bars([1,1,1]);
}


module borderize(thickness=thickness, ){
    difference(){
        minkowski(){
            children();
            cylinder(r=thickness,h=.0000000000000000001);
        }
        translate([0,0, -.01]) scale([1,1,2]) children();
    }
}
