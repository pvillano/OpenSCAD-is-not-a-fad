$fa = .01;
$fs = $preview ? 5 : .3;

// 1.2 works for layer height .05 .1 .15 .2 .3 .4

/*customizer*/

// 1.2 works for layer height .05 .1 .15 .2 .3 .4
layer_height = 1.2;
thin_wall_thickness=.45;
radius=30;
layers_per_step=10;
steps=9;
message="210-250";
d_column=7;

/*shortcuts*/

twt=thin_wall_thickness;

/*calculated*/
step_height = layers_per_step * layer_height;


for(i=[0:steps-1])
    rotate([0,0,i*120])
    translate([0,0,step_height*i])
{
    for(j=[0:2])
        rotate([0,0,j*120])
        translate([radius,0,0])
    {
        translate([0,0,layer_height])
            cylinder(d=d_column,h=step_height-layer_height);
        //snap off
        difference(){
            cylinder(d=d_column-twt,h=layer_height);
            translate([0,0,-.1])
                cylinder(d=d_column-2*twt,h=layer_height+.2);
            translate([-d_column/2,0,-.1])
                cube([d_column,twt,layer_height+.2]);
        }
    }
    translate([-radius/2,0,step_height-layer_height/2])
        cube([d_column,radius*sqrt(3),layer_height],center=true);
}
difference(){
    translate([0,0,-layer_height]) minkowski(){
        cylinder(r=radius,$fn=3,h=layer_height/2);
        cylinder(r=d_column,h=layer_height/2);
    }
    linear_extrude(layer_height/2,center=true)
    text(message, size=7, halign="center", valign="center");
}