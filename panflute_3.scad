//parameters

wall_thickness = 2.01; // mm for 4 walls .3mm layer height
top_shell = 1.2; // for 4 layers .3mm layer height

// constants
//len_A440 = 193.34; //mm
len_mid_c = 325.15; //mm
len_c_5 = len_mid_c / 2;
len_c_7 = len_c_5 / 4;
$fa = .01;
$fs = $preview ? 4 : 1;


module pan_pipe(n, interval, h_0){
    for(i=[0:n-1]){
        height = h_0 * pow(interval, i);
        diameter = height/10;
        dx = wall_thickness * i  + h_0/10 * pow(interval, i+.5)/(interval-1);
        translate([dx,0,0]){
            difference(){
                cylinder(h=height+top_shell,d=diameter+2*wall_thickness);
                cylinder(h=height,d=diameter);
            }
        }
    }
}

echo(len_c_5);
N=26;
pan_pipe(n=N, interval=pow(2,1/5), h_0 = 200/pow(2,(N-1)/5));