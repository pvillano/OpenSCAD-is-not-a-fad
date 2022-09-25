/* [measurements] */
fan_width = 80;
fan_thickness = 25; // [15, 25, 38.5]
fan_hole_spacing = 71.5; 
/* [Design Parameters] */
width = 80;
length = 70;
height = 200;
wall_thickness = 1.28;
hole_size=5;
hole_spacing=7;
hole_margin=1.28;

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

module holify(width,length, thickness, hole_size, hole_spacing, center=false){
	x_count = floor((width)/hole_spacing);
	y_count = floor((length)/hole_spacing);
	x0=(width-hole_spacing*(x_count-1))/2 - (center ? width/2: 0);
	y0=(length-hole_spacing*(y_count-1))/2 - (center ? length/2: 0);
	
	for(i=[0:x_count-1], j=[0:y_count-1]){
			translate([i*hole_spacing+x0, j*hole_spacing+y0,0]) cylinder(h=thickness+.2,d=hole_size, center=true, $fn=4);
	}
	for(i=[.5:x_count-1.5], j=[.5:y_count-1.5]){
			translate([i*hole_spacing+x0, j*hole_spacing+y0,0]) cylinder(h=thickness+.2,d=hole_size, center=true, $fn=4);
	}
}

module air_filter(){
	tilt_angle = acos(length/fan_width);
	h1 = height - fan_width * sin(tilt_angle) - fan_thickness * cos(tilt_angle);

	%translate([0,0,h1+.1]) rotate([acos(length/fan_width),0,0]) fan();
	
	difference(){
		cube([width,length,height]);
		difference(){
		//hollow
			translate(wall_thickness*[1,1,1])
				cube([width,length,height]-2*wall_thickness*[1,1,1]);
			translate([0,0,h1])
				rotate([acos(length/fan_width),0,0])
				translate([-.1,-.1,-wall_thickness])
				cube(999);
		}
		//angle
		translate([0,0,h1]) rotate([acos(length/fan_width),0,0]) translate([-.1,-.1,0]) cube(999);
		//cylinder
		//translate([0,0,h1]) rotate([acos(length/fan_width),0,0]) translate([0.5*fan_width, 0.5*fan_width, -wall_thickness-.1]) cylinder(h=fan_thickness+.2, d=0.9*fan_width);
		
		translate([hole_margin,0,hole_margin]) rotate([90,0,0]) holify(width-2*hole_margin, h1-2*hole_margin, length, hole_size, hole_spacing);
	}
}

air_filter();