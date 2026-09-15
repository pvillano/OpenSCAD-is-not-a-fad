from itertools import chain, product
from math import pi, sin, cos, ceil, atan

from libraries.stl import STLBuffer

outer_diameter = 200
h = 200
depth = 7
layer_height = .35
cell_width = 9
nozzle_diameter = .6

# unchanging
first_layer = .2
filter_od_unused = 175

sector_count = round(pi*outer_diameter/cell_width/4)*2+1
extrusion_width = .75*nozzle_diameter
inner_diameter = outer_diameter - 2*depth

n = ceil(h / layer_height * sector_count)+1

type Point = tuple[float, float, float]
type Triangle = tuple[Point, Point, Point]
type Quad = tuple[Point, Point, Point, Point]

def coord(i: int,offset: float = 0, *, r: float=outer_diameter/2 ) -> Point:
    theta = i * 2 * pi/sector_count + offset
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

def main():

    stlOut = STLBuffer()

    half_angle_outer = atan(extrusion_width/outer_diameter)
    half_angle_inner = atan(extrusion_width/inner_diameter)
    a0_a1 = 2*half_angle_outer
    a0_a1a = half_angle_outer + half_angle_inner
    a2_a2a = half_angle_outer - half_angle_inner
    for i in range(-sector_count,n):

        a0, a2 = i, i+1

        p00 = coord(a0)
        p10 = coord(a0, a0_a1)
        p20 = coord(a2)
        p10a = coord(a0, a0_a1a, r=inner_diameter/2)
        p20a = coord(a2, a2_a2a, r=inner_diameter/2)

        p01 = coord(a0+sector_count)
        p11 = coord(a0+sector_count, a0_a1)
        p21 = coord(a2+sector_count)
        p11a = coord(a0+sector_count, a0_a1a, r=inner_diameter/2)
        p21a = coord(a2+sector_count, a2_a2a, r=inner_diameter/2)


        # quads, verts are ccw from lower left
        before = (p00, p10, p11, p01)
        hole = (p10, p20, p21, p11)

        if i < 0:

            # pull the top coord down to force a degenerate tri
            p00 = (p01[0], p01[1], 0)
            p10 = (p11[0], p11[1], 0)
            p20 = (p21[0], p21[1], 0)

            before = (p00, p10, p11, p01)
            hole = (p10, p20, p21, p11)
            stlOut.write_triangles(quad_to_tris(before))
            stlOut.write_triangles(quad_to_tris(hole))

            # put another layer below
            h0 = -.2-layer_height/2+.001

            p01, p11, p21 = p00, p10, p20
            p00 = (p01[0], p01[1], h0)
            p10 = (p11[0], p11[1], h0)
            p20 = (p21[0], p21[1], h0)

            before = (p00, p10, p11, p01)
            hole = (p10, p20, p21, p11)
            stlOut.write_triangles(quad_to_tris(before))
            stlOut.write_triangles(quad_to_tris(hole))

            pzero = (0,0,h0)
            strip0 = (p00, pzero, p10)
            strip1 =(p10, pzero, p20)

            stlOut.write_triangle(strip0,)
            stlOut.write_triangle(strip1)
        elif i >= n-sector_count:
            h = coord(n)[2]
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
