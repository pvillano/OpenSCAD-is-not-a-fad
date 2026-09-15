/**

final in vase mode:   10:45
final in regular mode 32:14
*/



outer_diameter = $preview ? 20: 200;

h = $preview ? 20 : 200;
// depth of the ventilation cells
depth = 5;
layer_height = .3;
cell_width = 8;
nozzle_diameter = .6;
solid_layers_height = 1.;
/* [unchanging] */
first_layer = .2;
filter_od_unused = 175;

module _(){}

$fs = 1;
$fa = 0.1;

//shorthands
od = outer_diameter;

//calculated

//even number for symmetry reasons
wedge_count = round(3.1415*od/cell_width/4)*2;
layer_count = ceil((h-.2)/layer_height)+1;

module wedge(){
    w=od/2+2*nozzle_diameter;
    off = .75*nozzle_diameter;
    render() intersection(){
        translate([0,-off,0])
            cube([w,w,layer_height+.01]);
        
        translate([-off,0,0])
            rotate([0,0,-90+360/wedge_count/2+.1])
            cube([w,w,layer_height+.01]);
    }
}

module layer(){
    for(j=[0:wedge_count-1]){
        rotate([0,0,j/wedge_count*360])
            wedge();
    }
}

intersection(){
    cylinder(d=od, h=h, $fn=wedge_count*2);
    union(){
        for(i=[0:layer_count])
        translate([0,0,(i-1)*layer_height+.2])
        rotate([0,0,((i%2)/2)/wedge_count*360])
        layer();
    }
    
}

// solidation of center
cylinder(d=od-2*depth, h=h, $fn=wedge_count*2);

//bottom solid layers
cylinder(d=od, h=solid_layers_height, $fn=wedge_count*2);
