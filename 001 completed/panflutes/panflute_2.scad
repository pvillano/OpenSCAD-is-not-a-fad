//parameters

wall_thickness = 2.01; // mm for 4 walls .3mm layer height
top_shell = 1.2; // for 4 layers .3mm layer height

// constants
//len_A440 = 193.34; //mm
len_mid_c = 325.15; //mm
len_c_5 = len_mid_c / 2;
len_c_7 = len_c_5 / 4;
half_step =  pow(2, 1/22);
$fa = .01;
$fs = $preview ? 4 : 1;


module pan_pipe(n, interval, h_0){
    for(i=[0:n-1]){
        height = h_0 * pow(interval, i);
        diameter = height/10;
        dx = wall_thickness * i  + h_0/10 * pow(interval, i+.5)/(interval-1);
        translate([dx,diameter/2+5,0]){
            difference(){
                cylinder(h=height+top_shell,d=diameter+2*wall_thickness);
                cylinder(h=height,d=diameter);
            }
        }
    }
}


height = len_c_7 * pow(2, 10/22);

pan_pipe(n=23, interval=half_step*half_step, h_0 = height);
mirror([0,1,0]) pan_pipe(n=22, interval=half_step*half_step, h_0 = height*half_step);