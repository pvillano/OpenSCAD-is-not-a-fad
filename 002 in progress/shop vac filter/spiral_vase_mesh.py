from itertools import chain, product
from math import pi, sin, cos, ceil

from libraries.stl import STLBuffer

outer_diameter = 20
h = 20
depth = 1
layer_height = 4.3
cell_width = 8
nozzle_diameter = 5.6
od = outer_diameter
solid_layers_height = 1.

# unchanging
first_layer = .2
filter_od_unused = 175

sector_count = round(pi*outer_diameter/cell_width/4)*2+1
extrusion_width = .75*nozzle_diameter
inner_diameter = outer_diameter - 2*depth

n = ceil(h / layer_height * sector_count)
h = n * layer_height / sector_count # top layer is simpler this way

type Point = tuple[float, float, float]
type Triangle = tuple[Point, Point, Point]
type Quad = tuple[Point, Point, Point, Point]

def coord(theta: float,r: float=outer_diameter/2 ) -> Point:
    return r * cos(theta), r * sin(theta), theta / (2 * pi) * layer_height

def quad_to_tris(quad: Quad) -> tuple[Triangle, Triangle]:
    ret = []
    for tri in [(quad[0], quad[1], quad[2]), (quad[0], quad[2], quad[3])]:
        if tri[0] == tri[1] or tri[1] == tri[2] or tri[2] == tri[0]:
            print(f"Warning: degenerate triangle {tri}")
        else:
            ret.append(tri)
    return tuple(ret)

"""
Each sector is seven quads
five for the inset,
    one below,
and one to the side

p01--------p11----------------p21
||| before |||     hole?     |||
p00--------p10----------------p20
a0         a1                 a2

p11--------------------p21
 |  \\      top     //  | 
 |    p11a------p21a    | 
 |  L  ||  back  ||  R  | 
 |    p10a------p20a    | 
 |  //    bottom    \\  | 
p10--------------------p20
a1   a1a        a2a    a2
"""

# this should not do anything
h = coord(n * 2*pi/sector_count)[2]

def main():

    stlOut = STLBuffer()

    for i in range(-sector_count,n):

        # adding 2pi later introduces rounding errors
        # putting this first makes sure I didn't miss a renamed reference
        a02pi = (i+sector_count) * 2*pi/sector_count
        a12pi = a02pi + extrusion_width/(outer_diameter*pi)*2*pi
        a1a2pi = a02pi + extrusion_width/(inner_diameter*pi)*2*pi #slightly larger than a1a
        a22pi = ((i+sector_count) + 1 ) * 2*pi/sector_count
        a2a2pi = a22pi - (a1a2pi - a12pi)

        a0 = i * 2*pi/sector_count
        a1 = a0 + extrusion_width/(outer_diameter*pi)*2*pi
        a1a = a0 + extrusion_width/(inner_diameter*pi)*2*pi #slightly larger than a1a
        a2 = (i + 1 ) * 2*pi/sector_count
        a2a = a2 - (a1a - a1)

        p00 = coord(a0)
        p10 = coord(a1)
        p20 = coord(a2)
        p10a = coord(a1a, inner_diameter/2)
        p20a = coord(a2a, inner_diameter/2)

        p01 =   coord(a02pi)
        p11 =   coord(a12pi)
        p21 =   coord(a22pi)
        p11a = coord(a1a2pi, inner_diameter/2)
        p21a = coord(a2a2pi, inner_diameter/2)


        # quads, verts are ccw from lower left
        before = (p00, p10, p11, p01)
        hole = (p10, p20, p21, p11)

        if i < 0:
            pzero = (0,0,0)

            # pull the top coord down to force a degenerate tri
            p00 = (p01[0], p01[1], 0)
            p10 = (p11[0], p11[1], 0)
            p20 = (p21[0], p21[1], 0)

            before = (p00, p10, p11, p01)
            hole = (p10, p20, p21, p11)
            strip0 = (p00, pzero, p10)
            strip1 =(p10, pzero, p20)

            # TODO: can create a degenerate triangle
            stlOut.write_triangles(quad_to_tris(before))

            stlOut.write_triangles(quad_to_tris(hole))
            stlOut.write_triangle(strip0,)
            stlOut.write_triangle(strip1)
        elif i >= n-sector_count:
            pzero = (0,0,h)

            #pull the bottom coord up to get a degenerate tri
            p01 = (p00[0], p00[1], h)
            p11 = (p10[0], p10[1], h)
            p21 = (p20[0], p20[1], h)

            before = (p00, p10, p11, p01)
            hole = (p10, p20, p21, p11)
            strip0 = (p11, pzero, p01)
            strip1 =(p21, pzero, p11)

            stlOut.write_triangles(quad_to_tris(before))

            # TODO: can create a degenerate triangle
            stlOut.write_triangles(quad_to_tris(hole))
            stlOut.write_triangle(strip0)
            stlOut.write_triangle(strip1)
        elif i%2 == 0:
            # first is never a hole
            stlOut.write_triangles(quad_to_tris(before))
            stlOut.write_triangles(quad_to_tris(hole))
        elif i == n-sector_count - 1:
            # last is never a hole
            stlOut.write_triangles(quad_to_tris(before))
            stlOut.write_triangles(quad_to_tris(hole))
        else:
            stlOut.write_triangles(quad_to_tris(before))

            left = (p10, p10a, p11a, p11)
            bottom = (p10, p20, p20a, p10a)
            right = (p20a, p20, p21, p21a)
            top = (p11a, p21a, p21, p11)
            back = (p10a, p20a, p21a, p11a)
            quads = [left, bottom, right, top, back]
            tris = chain.from_iterable(quad_to_tris(quad) for quad in quads)

            stlOut.write_triangles(tris)

    with open("output.stl", "wb") as f:
        f.write(stlOut.getvalue())
if __name__ == '__main__':
    main()
