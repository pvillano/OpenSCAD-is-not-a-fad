slop = .2;
thin_wall_thickness = 1.67;

strip_width = 10.25 + slop*2;
strip_thickness = .50 + slop;
strip_margin = (10.25-7.75)/2;

bezel_width = 6.25 - slop;
frame_width = 2.41 + slop;
frame_thickness = 22.4 + slop;
clip_over = max(.60, 2.49 - thin_wall_thickness);

back_length = bezel_width*3;
preload_degrees = 5;

thickness = 10;

clip_width = bezel_width + frame_width + thin_wall_thickness;

translate([-bezel_width, 0,0]) cube([bezel_width, clip_over, thickness]);
translate([-bezel_width, -thin_wall_thickness, 0]) cube([clip_width, thin_wall_thickness, thickness]);
translate([frame_width,0,0]) cube([thin_wall_thickness, frame_thickness, thickness]);
translate([-back_length+frame_width+thin_wall_thickness, frame_thickness, 0])
    translate([back_length,0,0])
    rotate([0,0,preload_degrees])
    translate([-back_length,0,0])
    cube([back_length, thin_wall_thickness, thickness]);

translate([0,-(strip_thickness+2*thin_wall_thickness),0]){
    difference(){
        cube([strip_width+2*thin_wall_thickness, strip_thickness+2*thin_wall_thickness, thickness]);
        translate([thin_wall_thickness, thin_wall_thickness, 0])
            cube([strip_width, strip_thickness, thickness]);
        translate([thin_wall_thickness + strip_margin,0,0])
            cube([strip_width - 2*strip_margin, thin_wall_thickness, thickness]);
    }
}