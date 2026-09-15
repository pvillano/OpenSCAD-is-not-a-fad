import datetime
import struct
import sys
from io import BytesIO
from itertools import chain

type Point = tuple[float, float, float]
type Triangle = tuple[Point, Point, Point]

def normal(triangle: Triangle) -> Point:
    p0, p1, p2 = triangle

    # Compute two edge vectors from p0
    v1 = (p1[0] - p0[0], p1[1] - p0[1], p1[2] - p0[2])
    v2 = (p2[0] - p0[0], p2[1] - p0[1], p2[2] - p0[2])

    # Compute the cross product (v1 x v2)
    nx = v1[1] * v2[2] - v1[2] * v2[1]
    ny = v1[2] * v2[0] - v1[0] * v2[2]
    nz = v1[0] * v2[1] - v1[1] * v2[0]

    # Calculate the magnitude of the normal vector
    length = (nx**2 + ny**2 + nz**2) ** 0.5

    # Handle degenerate triangles where points are collinear
    if length == 0.0:
        return 0.0, 0.0, 0.0

    # Return the normalized unit vector
    return nx / length, ny / length, nz / length

class STLBuffer:
    """
    Incrementally encodes a binary STL file.
    Get the final file with getvalue().
    """
    buffer: BytesIO
    facet_count = 0

    def __init__(self):
        self.buffer = BytesIO()

    def write_triangle(self, triangle: Triangle):
        normalVec = normal(triangle)

        # output normal
        self.buffer.write(struct.pack('3f', *normalVec))

        # output points
        self.buffer.write(struct.pack('9f', *chain.from_iterable(triangle)))

        # legacy 2 byte
        self.buffer.write(struct.pack('xx'))

        self.facet_count += 1

    def get_header(self) -> bytes:
        s = f"Generated on {datetime.datetime.now().isoformat()}"
        return s.encode().ljust(80) + struct.pack('i', self.facet_count)

    def getvalue(self) -> bytes:
        b = BytesIO()
        b.write(self.get_header())
        b.write(self.buffer.getvalue())
        return b.getvalue()


# if __name__ == '__main__':
#     filename = sys.argv[1] if len(sys.argv) > 1 else "out.stl"
#     with open(filename, mode='wb') as f:
#         p = ((0,0,0),(0,0,100),(0,100,0),(100,0,0))
#         tris = [(p[0], p[1], p[2]),
#                 (p[0], p[2], p[3]),
#                 (p[0], p[3], p[1]),
#                 (p[3], p[2], p[1]),]
#         sb = STLBuffer()
#         for triangle in tris:
#             sb.write_triangle(triangle)
#         f.write(sb.getvalue())
