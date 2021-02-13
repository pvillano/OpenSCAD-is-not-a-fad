

x_max = 210;
y_max = 250;
z_max = 200;
num_points = 100;

//thanks to http://forum.openscad.org/Simple-hyperbola-tp9820p9841.html
function points() = concat([ for (z = [-num_points/2 : num_points/2]) [num_points/4 + z * z / num_points, z] ], [ [0, num_points/2], [0, -num_points/2] ]);
resize([x_max, y_max, z_max]){
    rotate_extrude($fn = num_points) polygon(points());
}