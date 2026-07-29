width = 203.38;
height = 131.11;
thickness = 3.93;
rotate_90 = false;

type = "twin cones beside"; // ["half shell", "twin cones behind", "twin cones beside"]
mouse_ears = 0;

// how many layers between bridges.
period=5;
stick_out=3;

nozzle = .6;
layer_height = .3;

module _stop_customizer() {}

xyz = rotate_90 ? [0,height,width] : [0,width,height];
twt = nozzle * 1.1;
$fs=1.;
$fa=.01;

module mirror2(xyz){
    children();
    mirror(xyz) children();
}

module halfShell() render() rotate([0,0,-90])difference() {
    // base cylinder
    cylinder(d=xyz.y, h=xyz.z);
    // hollowed, minus brim
    translate([0,0,.2]) cylinder(d=xyz.y-2*twt, h=xyz.z);
    // hollow brim
    cylinder(d=xyz.y-2*twt-20, h=xyz.z);
    // brim don't touch
    scale([1,.2,1])cylinder(d=xyz.y-2*twt, h=xyz.z);
    // cut in half
    translate([-xyz.y/2,0,0]) cube([xyz.y,xyz.y,xyz.z]);
//    #hull(){
//        translate([0,0,xyz.z])cube([xyz.y,0.1,0.1], center=true);
//        translate([0,-xyz.y/2,xyz.z/2])
//        cube([xyz.y,0.1,xyz.z], center=true);
//    }
}

module cone(){
    base_d = max(15,xyz.z/4);
    render() difference(){
        union(){
            hull(){
                //base
                translate([-base_d/2,0,0]) cylinder(d=base_d,h=.2);
                //tip
                translate([-2*twt/2,0,0]) cylinder(d=2*twt+.0001,h=xyz.z);
                //translate([0,0,xyz.z]) sphere(.5);
            }

            // attachment ribs
            n=floor((xyz.z-.2)/layer_height/period);
            for(i=[1:n]){
                translate([-twt,-twt/2,.2+(i-1/period)*layer_height*period])
                    cube([twt+stick_out,twt,layer_height]);
            }
            translate([-twt,-twt/2,0])
                cube([twt+stick_out,twt,.2]);
        }
        hull(){
            translate([-base_d/2,0,.24]) cylinder(d=base_d-2*twt,h=.001);
            translate([-2*twt/2,0,0]) cylinder(d=.0001,h=xyz.z);
        }
        // debug thickness
        //translate([-max(width, height)/2,0,0]) cube(max(width, height));
    }
    if(mouse_ears>0) translate([-mouse_ears/2,0,0]) cylinder(d=mouse_ears,h=.2);
}

// ghost of the frame
%translate([0,-xyz.y/2,0]) cube([thickness,xyz.y,xyz.z]);

if(type == "half shell"){
    halfShell();
} else if (type == "twin cones behind"){
    mirror2([0,1,0]) translate([-stick_out/2,xyz.y/2-twt,0]) cone();
} else if (type == "twin cones beside"){
    mirror2([0,1,0]) translate([thickness/2,-xyz.y/2-stick_out/2,0]) rotate([0,0,90]) cone();
} else {
    rotate([0,0,30]) text("error", halign="center");
}

%rotate([180,0,atan(250/210)]) linear_extrude(1) square([250,210], center=true);
