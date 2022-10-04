$fa = .01;
$fs = 1;

/* [measurements] */
fan_width = 80;
fan_thickness = 38.5; // [15, 25, 38.5]
fan_hole_spacing = 71.5;
fan_hole_diameter=4.9;
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
lid_thickness=7;
//length of support for head of the screw
screw_meat = 6;
max_overhang=20;
module __Customizer_Limit__(){};

assert(fan_width == width); // TODO

tilt_angle = acos(length/fan_width);

safe_lid_thickness = max(lid_thickness, wall_thickness);
fanless_h = height - fan_thickness * cos(tilt_angle);
lid_h = fan_width * sin(tilt_angle) + safe_lid_thickness;

base_h = fanless_h - lid_h;

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
  //points down with head of screw flush with xy plane
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
		if(!$preview) for(i=[0:x_count-1], j=[0:y_count-1]){
				translate([i*hole_spacing+x0, j*hole_spacing+y0])
          circle(d=hole_size, $fn=4);
		}
		if(!$preview) for(i=[.5:x_count-1.5], j=[.5:y_count-1.5]){
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



module lid(){
	difference(){
    //box for carving
		translate([0,0,-safe_lid_thickness])
      cube([width,length,lid_h]);
		//diagonal fan 
		rotate([tilt_angle,0,0])
		 translate([-.1,-.1,0])
		 cube([fan_width+.2,fan_width+.2,999]);
		//air path
		hull(){
			translate([width/2,length/2,-safe_lid_thickness+wall_thickness-.1])
				cube([width,length,.1] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
			rotate([tilt_angle,0,0])
				translate([fan_width/2,fan_width/2,.1]) intersection(){
          cylinder(h=.01, d=fan_width);
          cube(fan_width-2*wall_thickness, center=true);
        }
          
		}
    translate([width/2,length/2,0])
      cube([width,length,2*safe_lid_thickness+.2] -2*(media_thickness+wall_thickness)*[1,1,0], center=true);
     
		//screw mounting holes
  rotate([tilt_angle,0,0])
    for_each_corner(fan_width, fan_width)
      translate([(fan_width-fan_hole_spacing)/2, (fan_width-fan_hole_spacing)/2, -screw_meat])
      mirror([0,0,1]) screw_clearance();
      
   
  tab_w2 = (media_thickness+wall_thickness)/2;
  for_each_corner(width, length);
    for_each_corner(width, length) 
      translate([tab_w2,tab_w2,-safe_lid_thickness-.1])
      cylinder(h=magnet_height+.1,d=magnet_diameter);
	}
}

module body_positive(){
  //floor
  hull(){
    cube([width,length,wall_thickness]);
    translate(wall_thickness/2*[1,1,-1])
    cube([width-wall_thickness,length-wall_thickness,wall_thickness]);
  }
	
  //outer mesh
	mesh_box(width,length,base_h);
  //inner mesh
	translate([media_thickness,media_thickness,0])
		mesh_box(width-2*media_thickness,length-2*media_thickness,base_h);
  //dividers
  for_each_corner(width, length)
    rotate([90,0,45])
		translate([wall_thickness/sqrt(2),0,0])
		linear_extrude(wall_thickness, center=true)
		mesh(media_thickness*sqrt(2),base_h, hole_size, hole_spacing);

  //corner pyramids 
  tab_w = media_thickness+wall_thickness;
  slope=sqrt(2)*tan(max_overhang); // base of tri is diagonal
  for_each_corner(width, length) hull(){
    translate([0,0,base_h-wall_thickness]) cube([tab_w,tab_w,wall_thickness]);
    translate([0,0,base_h-wall_thickness-media_thickness*slope]) cube(wall_thickness);
  }
    
}

module body(){
  difference(){
    body_positive();
    
    tab_w2 = (media_thickness+wall_thickness)/2;
    for_each_corner(width, length) 
      translate([tab_w2,tab_w2,base_h-magnet_height])
      cylinder(h=magnet_height+.1,d=magnet_diameter);
    if ($preview) translate([width/2,-1000+length/2,base_h/2]) cube(1000);
  }
}

module assembly(){
	body();
	translate([0,0,base_h+4+safe_lid_thickness]){
		lid();
		%rotate([tilt_angle,0,0]) fan();
	}
}

assembly();

	