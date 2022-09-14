// Novel spherical bisections and quadrisections for OpenSCAD
// Scott Elliott - 2 May 2010
// NOTE: most cylinders and spheres include the $fa variable to increase resolution, at the expense of VERY LONG RENDER TIMES

// conetorus builds a donut-like shape, a sphere with cones removed on opposite sides.
// A 'perfect' part would use a cone whose max radius equals the sphere radius, but I deviated slightly to create a 'grip' between pieces
// Peter Villano 2 September 2021
// Fixed bugs, improved formatting, changed representation of tolerances
$fa = .01;
$fs = $preview ? 5 : 1;
slop = .2;

module conetorus(radius) {
	difference() {
        sphere(r=radius);
		cylinder(h=radius, r1=slop, r2=radius+slop); // upper cone removal
		rotate([180,0,0])
            cylinder(h=radius, r1=slop, r2=radius+slop); // lower cone removal
		cylinder(r=slop,h=radius, center=true, $fn=ceil(radius*2*PI/$fs)); // protect mesh between the cones (to avoid 0-height mesh between them)
	}
}

// demisphere builds 1 spheric bisection, two halves that snap together
module demisphere(radius) {
	difference() { conetorus(radius);
		rotate([90,0,0]) intersection() { 
			conetorus(radius+1); 
			translate([radius,0,0]) cube(size=radius*2,center=true);
		}
	}
}

// hemidemisphere builds 1 spheric quadrisection by cutting each demisphere in half, four quarters that snap together
module hemidemisphere(radius) {
	intersection() {
        demisphere(radius);
        translate([0,0,radius+slop])
            cube(size=(radius+slop)*2, center=true);
    } // top half only
}

// hollowhemidemisphere digs a hollow channel out of the back of a hemidemisphere.
// these parts are stackable and conserve material, but include a 45-degree overhang
module hollowhemidemisphere(radius, offset) {
	difference() {
		hemidemisphere(radius);
		translate([0,0,-offset])
            hemidemisphere(radius);
	}
}

//demisphere(24);
hemidemisphere(30);
//hollowhemidemisphere(24, 7);