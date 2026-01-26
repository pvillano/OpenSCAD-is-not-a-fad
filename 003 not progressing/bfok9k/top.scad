
// non-design measurements
key_spacing = 19.05;
key_cutout_w = .551*25.4;

wall_thicc = 1.28;
pcb_thickness = 1.62;
difference(){
    translate([-wall_thicc,-wall_thicc,0])
        cube([key_spacing*9+2*wall_thicc, key_spacing*6+2*wall_thicc, pcb_thickness]);
    for(i=[.5:9.5],j=[.5:6.5]){
        translate([i*key_spacing, j*key_spacing, pcb_thickness/2]) cube([key_cutout_w,key_cutout_w,pcb_thickness*2], center=true);
    }
}