side_length = 10;
first_layer_height =.2;
thin_wall_thickness=1.28;
stick_out = 3;

rotate(45){
    cube([side_length, side_length, first_layer_height], center=true);
    cube([side_length+stick_out, thin_wall_thickness, first_layer_height], center=true);
    cube([thin_wall_thickness, side_length+stick_out,first_layer_height], center=true);
}