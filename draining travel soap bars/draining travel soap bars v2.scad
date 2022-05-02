$fs = $preview ? 10 : 1;
sides=6;
// should include slop!
h_soap = 15;
// should include slop!
d_soap = 40;
wall_thickness = 4;
foot_height = 8;

h_magnet = 2;
d_magnet = 4;

hole_spacing = 15;
hole_percent = 75;
/*
# travel soap container
draining epoxy-coated travel soap bar container

## constraints
I want to make something to hold my travel soap bars with the following constraints
1. waterproof - sealed with epoxy resin
2. draining
3. compact
4. sealed completely when closed
5. doesn't drain on top of eachother
6. needs to hold 3 pucks: soap, shampoo, conditioner

## ideation
* so one design could be like stacking cups with two diameters, holes on the bottom and a lid on top.
    * the bottommost one needs an extra lid for transport
* what if there was a shaft that the holders swung out from?
* what if I got some tins -> no draining
* what if it was held together with magnets? then I wouldn't have to worry about expoxy affecting clearances

## final design
five parts: a top lid, three chambers and a bottom lid. hexagons, just for funsies

##for version 2
the chambers could have three sloping feet that nest with the chamber below. one traingle wave
*/
/*
* the problem is making it seal e. the geometry of the top must mate with the geometry of the bottom
* even though both have a coat of epoxy of an unknown thickness! this is not trivial...
    * a ball and socket is not possible
    * two planes does work
    * a cone works
    * a corner to a corner works
    * not sure about saddles
* the problem can be formalied as follows: find two surfaces embedded in 3d space such that when either surface is
       explanded in the local normal direction they can still mate
 */

/*
I did this on paper, but the mesh is built like a tube, with points arranged "spiraling" along it's "length".
since the pattern of points is periodic, generating the faces is "easy" as 1234,2345,3456...
the tube loops back on itself, so the final faces are 7891,8912,9123
 */
/*
none of this really matters since I already decided that the corners will touch the ground at two points
Edit: this is impossible i think
for a loop of edges to be a polygon, they must all lie in the same plane
for a quadrilateral, two opposite are skew iff the other pair of opposite edges are skew.

* option 1:/ interpolate the saddles, sweeping opposite edges, creating a saddle
    * might interfere with fit
* option 2:) attempt to exploit/discover remaining degrees of freedom so that it's all neat polygons
    * :( foot could touch ground at an angle
    * :( walls could have uneven thickness wait no that doesn't matter
    * :'D tilt troughs up and peaks down. point both to the same point on the z axis
* option 3:( make every saddle concave
* option 4:( match concave and convex saddles
*/

r_0 = d_soap / 2 * (1 / sin(60));
r_1 = (d_soap / 2 + wall_thickness) * (1 / sin(60));
h_0 = 0;
h_1 = h_soap;


//r, theta, phi
function sph2cart(rtp) = [rtp.x*sin(rtp.y)*cos(rtp.z), rtp.x*sin(rtp.y)*sin(rtp.z), rtp.x*cos(rtp.y)];

wobble = 6;

//todo account for wobble in real r0 r1, available height
// todo strainer
// todo sides, also on v1
proto_points = [[r_0, h_0], [r_0, h_1], [r_1, h_1], [r_1, h_0]];
function sector(idx, wobble) = [for (pp=proto_points) (sph2cart([pp[0], wobble, idx*360/sides]) + [0,0,pp[1]])];

points = [for (i=[1:sides]) each sector(i, 90-wobble*(2*(i%2)-1))];
//for(point=points)translate(point) cube(center=true);
proto_faces = [[0,4,7,3], [1,5,4,0],[2,6,5,1],[3,7,6,2]];
faces = [for(i=[0:5]) each [for (pf=proto_faces) [for(j=pf) (j+i*4)%len(points)]]];
polyhedron(points=points,faces=faces);