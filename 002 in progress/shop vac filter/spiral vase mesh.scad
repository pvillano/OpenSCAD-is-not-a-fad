// there is a spiral of points
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

//
wedge_count = round(3.1415*od/cell_width/4)*2;
layer_count = ceil((h-.2)/layer_height)+1;

angles = [for (i = [0 : wedge_count-1]) i*360/wedge_count];

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

/* [calculated] */

//odd number so that "layers" "alternate"
sector_count = round(3.1415*od/cell_width/4)*2+1;
echo("sector_count", sector_count);

module wedge(){
  w=od/2+2*nozzle_diameter;
  off = .75*nozzle_diameter;
  h2 = layer_height * sector_count/(sector_count-1);
  render() intersection(){
    translate([0,-off,0])
      cube([w,w,h2]);

    translate([-off,0,0])
      rotate([0,0,-90+360/sector_count+.1])
        cube([w,w,h2]);
  }
}

intersection(){
  cylinder(d=od, h=h, $fn=sector_count);
  union(){
    n=h/layer_height*sector_count;
    for(i=[0:2:n])
    translate([0,0,(i-1)*h/n+.2])
      rotate([0,0,i/sector_count*360])
        wedge();
  }

}

// solidation of center
cylinder(d=od-2*depth, h=h, $fn=sector_count);

//bottom solid layers
translate([0,0,-.01])cylinder(d=od, h=solid_layers_height, $fn=sector_count);
