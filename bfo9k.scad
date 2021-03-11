/*
 * consider sawing of jack
 * consider rounding corners
 * front needs design
 * find min height
 * add jacks
 * add reset button
 */

// non-design measurements
key_spacing = 19.05;
key_cutout_w = .551*25.4;

pcb_x = 171.45;
pcb_y = 116.60;
pcb_y2 = 111.8;
bump_out = pcb_y - pcb_y2;
bump_in = 6*key_spacing - pcb_y2;
pcb_thickness = 1.62;
bump1_x = 19.12; // from the other side
bump1_w = 42.33;
bump2_x = 53.7;
bump2_w = 7.00;

usb_pcb_thicc = 3.14;
usb_pcb_width = 18.53;


//distance from the top of the pcb to the
top_layer_thickness = .197 * 25.4;
// distance from the bottom of the pcb to the bottom of the keycaps
a = .43*25.4;
// distance from the top of the case to the bottom of the pcb
cutout_h = .20 * 25.4 + pcb_thickness;

stud_diameter = 4.0;
stud_locations = [
    [1,1], [1,2], [1,3], [1,4],
    [3,1], [3,2], [3,3], [3,5],
    [6,1], [6,2], [6,3], [6,5], 
    [8,1], [8,2], [8,4], [8,5], 
];

// design measurements

//layer_height = .35;
wall_thicc = 1.28;
bott_solder_room = 3;
// doesn't actually include top layer
tot_height = cutout_h + usb_pcb_thicc + 2 * pcb_thickness + bott_solder_room; 

module top_test(){
    difference(){
        cube([key_spacing,key_spacing,pcb_thickness], center=true);
        cube([key_cutout_w,key_cutout_w,pcb_thickness*2], center=true);
    }
}

module top_layer_old(){
    difference(){
        for(i=[.5:9.5],j=[.5:6.5]){
            translate([i*key_spacing, j*key_spacing, pcb_thickness/2]) cube([key_cutout_w,key_cutout_w,pcb_thickness*2], center=true);
        }
    }
}

module top_shell(){
    //top part
    difference(){
        translate([-wall_thicc,-wall_thicc,0])
            cube([key_spacing*9+2*wall_thicc, key_spacing*6+2*wall_thicc, pcb_thickness]);
        for(i=[.5:9.5],j=[.5:6.5]){
            translate([i*key_spacing, j*key_spacing, pcb_thickness/2]) cube([key_cutout_w,key_cutout_w,pcb_thickness*2], center=true);
        }
    }
    //walls
    #difference(){
        translate([-wall_thicc,-wall_thicc,-tot_height])
            cube([key_spacing*9+2*wall_thicc, key_spacing*6+2*wall_thicc, tot_height]);
        translate([0,0,-tot_height-1])
            cube([key_spacing*9, key_spacing*6, tot_height+2]);
        
        //gaps for jack, usb
        translate([key_spacing*9-bump1_x-bump1_w,-wall_thicc*1.5,-cutout_h-tot_height])
            cube([bump1_w,wall_thicc*2,tot_height]);
        translate([bump2_x,-wall_thicc*1.5,-cutout_h-tot_height])
            cube([bump2_w,wall_thicc*2,tot_height]);
    }
}
ungap_height = tot_height-cutout_h-pcb_thickness;
module bottom_shell(){
        cube([key_spacing*9, key_spacing*6, pcb_thickness]);
    //gaps for jack, usb
    translate([key_spacing*9-bump1_x-bump1_w,-wall_thicc,0]){
        difference(){
            cube([bump1_w,wall_thicc,ungap_height]);
            translate([bump1_w-usb_pcb_width,-wall_thicc/2,ungap_height-usb_pcb_thicc])
                cube([usb_pcb_width+.1,wall_thicc*2,usb_pcb_thicc+.1]);
        }
    }
    translate([bump2_x,-wall_thicc,0])
        cube([bump2_w,wall_thicc,ungap_height]);
    
}

translate([0,0,-2*tot_height]) #bottom_shell();

top_shell();

































