$fa = .01;
$fs = 1;

/* [measurements] */
fan_width = 80;
fan_thickness = 25; // [15, 25, 38.5]
fan_hole_spacing = 71.5;
fan_hole_diameter = 4.9;
/* [Design Parameters] */
width = 80;
length = 70;
height = 200;
wall_thickness = 2.5;
hole_size=3.5;
hole_spacing=4.2;
media_thickness=15;


tilt_angle = acos(length/fan_width);
h1 = height - fan_width * sin(tilt_angle) - fan_thickness * cos(tilt_angle);
h2 = h1 + fan_width * sin(tilt_angle);

module fan(){
	difference(){
		 cube([fan_width, fan_width, fan_thickness]);
		translate([0.5*fan_width, 0.5*fan_width, -.1]) cylinder(h=fan_thickness+.2, d=0.9*fan_width);
		for(i=[-1,1],j=[-1,1])
		translate(0.5*fan_hole_spacing*[i,j,0])
		translate([fan_width/2,fan_width/2,-.1])
		cylinder(h=fan_thickness+.2, d=4);
	}
}

module mesh(width,length, hole_size, hole_spacing, center=false){
	x_count = floor((width)/hole_spacing);
	y_count = floor((length)/hole_spacing);
	x0=(width-hole_spacing*(x_count-1))/2;
	y0=(length-hole_spacing*(y_count-1))/2;
	translate(center ? [-width/2,-length/2] : [0,0]) difference(){
		square([width,length]);
		for(i=[0:x_count-1], j=[0:y_count-1]){
				translate([i*hole_spacing+x0, j*hole_spacing+y0]) circle(d=hole_size, $fn=4);
		}
		for(i=[.5:x_count-1.5], j=[.5:y_count-1.5]){
				translate([i*hole_spacing+x0, j*hole_spacing+y0]) circle(d=hole_size, $fn=4);
		}
	}
}
module mesh_box(width, length,height){
	mirror([0,1,0]) rotate([90,0,0]) linear_extrude(wall_thickness) mesh(width,height, hole_size, hole_spacing);
	translate([0,length,0]) rotate([90,0,0]) linear_extrude(wall_thickness) mesh(width,height, hole_size, hole_spacing);

	rotate([90,0,90]) linear_extrude(wall_thickness) mesh(length,height, hole_size, hole_spacing);
	translate([width,0,0]) mirror([1,0,0]) rotate([90,0,90]) linear_extrude(wall_thickness) mesh(length,height, hole_size, hole_spacing);
}

module body(){
	cube([width,length,wall_thickness]);
	mesh_box(width,length,h1);
	translate([media_thickness,media_thickness,0])
		mesh_box(width-2*media_thickness,length-2*media_thickness,h1);
	rotate([90,0,45])
		translate([wall_thickness/sqrt(2),0,0])
		linear_extrude(wall_thickness, center=true)
		mesh(media_thickness*sqrt(2),h1, hole_size, hole_spacing);
		
	translate([width,0,0])
		rotate([90,0,135])
		translate([wall_thickness/sqrt(2),0,0])
		linear_extrude(wall_thickness, center=true)
		mesh(media_thickness*sqrt(2),h1, hole_size, hole_spacing);
	translate([width, length,0])
		rotate([90,0,225])
		translate([wall_thickness/sqrt(2),0,0])
		linear_extrude(wall_thickness, center=true)
		mesh(media_thickness*sqrt(2),h1, hole_size, hole_spacing);
	translate([0,length,0])
		rotate([90,0,-45])
		translate([wall_thickness/sqrt(2),0,0])
		linear_extrude(wall_thickness, center=true)
		mesh(media_thickness*sqrt(2),h1, hole_size, hole_spacing);
}

module lid(){
	difference(){
		translate([0,0,-wall_thickness]) cube([width,length,h2-h1+wall_thickness]);
		//diagonal
		rotate([tilt_angle,0,0])
		 translate([-.1,-.1,0])
		 cube([fan_width+.2,fan_width+.2,h2-h1]);
		//air path
		hull(){
			translate([width/2,length/2,-.1])
				cube([width,length,.1] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
			rotate([tilt_angle,0,0])
				translate([fan_width/2,fan_width/2,.1])
				cylinder(.001, d=fan_width);
		}
		translate([width/2,length/2,0])
			cube([width,length,3*wall_thickness] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
		mirror([0,0,1]) linear_extrude() offset(r=.1) projection(cut=true) translate([0,0,-h1+.01]) body();
		//screw mounting holes
		for(i=[-1,1],j=[-1,1])
			rotate([tilt_angle,0,0])
			translate(.5*[i*fan_hole_spacing+fan_width, j*fan_hole_spacing+fan_width,0])
			cylinder(h=30,d=fan_hole_diameter, center=true);
	}
}
module assembly(){
	body();
	translate([0,0,h1+4]){
		lid();
		%rotate([tilt_angle,0,0]) fan();
	}
}

assembly();
	