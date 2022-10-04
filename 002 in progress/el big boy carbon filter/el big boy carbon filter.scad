$fa = .01;
$fs = 1;

/* [measurements] */
fan_width = 80;
fan_thickness = 25; // [15, 25, 38.5]
fan_hole_spacing = 71.5;
fan_hole_diameter = 5;

magnet_diameter=8.1;
magnet_height=2.8;
/* [Design Parameters] */
width = 80;
length = 70;
height = 200;
wall_thickness = 2.5;
hole_size=3.5;
hole_spacing=4.2;
media_thickness=15;
wumbo=7;

max_overhang=20;

module __Customizer_Limit__(){};

tilt_angle = acos(length/fan_width);
h1 = height - fan_width * sin(tilt_angle) - fan_thickness * cos(tilt_angle);
h2 = h1 + fan_width * sin(tilt_angle);

module mirror2(xyz){
  children();
  mirror(xyz) children();
}


module for_each_corner(width, length){
  //expects feature relative to [0,0,0]
  // uses mirrors, not rotation
  translate([width/2, length/2,0])
  mirror2([0,1,0])
  mirror2([1,0,0])
  translate([-width/2, -length/2,0])
  children();
}

module screw_clearance(){
  //fans use kb5*10 screws
  mirror([0,0,1]) cylinder(h=10,d=5);
  hull(){
    cylinder(h=99,d=6.5);
    mirror([0,0,1]) cylinder(h=1.5,d=5);
  }
}

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
				translate([i*hole_spacing+x0, j*hole_spacing+y0])
          circle(d=hole_size, $fn=4);
		}
		for(i=[.5:x_count-1.5], j=[.5:y_count-1.5]){
				translate([i*hole_spacing+x0, j*hole_spacing+y0])
          circle(d=hole_size, $fn=4);
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
  for_each_corner(width, length)
    rotate([90,0,45])
		translate([wall_thickness/sqrt(2),0,0])
		linear_extrude(wall_thickness, center=true)
		mesh(media_thickness*sqrt(2),h1, hole_size, hole_spacing);

  tab_w = media_thickness+wall_thickness;
  slope=sqrt(2)*tan(max_overhang); // base of tri is diagonal
  for_each_corner(width, length) hull(){
    translate([0,0,h1-wall_thickness]) cube([tab_w,tab_w,wall_thickness]);
    translate([0,0,h1-wall_thickness-media_thickness*slope]) cube(wall_thickness);
  }
    
}

module lid(){
	difference(){
		translate([0,0,-wall_thickness-wumbo]) cube([width,length,h2-h1+wall_thickness+wumbo]);
		//diagonal
		rotate([tilt_angle,0,0])
		 translate([-.1,-.1,0])
		 cube([fan_width+.2,fan_width+.2,h2-h1]);
		//air path
		hull(){
			translate([width/2,length/2,-.1-wumbo])
				cube([width,length,.1] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
			rotate([tilt_angle,0,0])
				translate([fan_width/2,fan_width/2,.1])
				cylinder(.001, d=fan_width);
		}
		translate([width/2,length/2,0])
			cube([width,length,3*wall_thickness] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
     //wumbology
     translate([width/2,length/2,0]) cube([width,length,999] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
		//mirror([0,0,1]) linear_extrude() offset(r=.1) projection(cut=true) translate([0,0,-h1+.01]) body();
		//screw mounting holes
		for(i=[-1,1],j=[-1,1])
			rotate([tilt_angle,0,0])
			translate(.5*[i*fan_hole_spacing+fan_width, j*fan_hole_spacing+fan_width,0])
			cylinder(h=30,d=fan_hole_diameter, center=true);
	}
}
module body2() difference(){
  body();
  
  tab_w2 = (media_thickness+wall_thickness)/2;
  for(dx=[tab_w2,width-tab_w2],dy=[tab_w2,length-tab_w2])
  translate([dx,dy,h1-2])
    cylinder(h=3,d=6);
  if ($preview) translate([width/2,-1000+length/2,h1/2]) cube(1000);
}

module assembly(){
	body2();
	translate([0,0,h1+4+wumbo]){
		lid();
		%rotate([tilt_angle,0,0]) fan();
	}
}

body();

	