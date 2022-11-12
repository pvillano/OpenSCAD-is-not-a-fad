import cadquery as cq
from math import sqrt


# from http://gdstime.com/product/?99_543.html
fan_hole_spacing = 71.5
fan_width = 80.0
fan_thickness = 38
fan_wall_thickness = 2.0
screw_diameter = 4.0
nut_waf = 7
nut_h = 3
# measured
fan_back_od = 82.42
fan_front_od = 83.72
fan_back_id = 45.5
fan_front_id = 40
# design parameters
h = 30
fillet_radius = 4

box = (
    cq.Workplane("XY").box(fan_width, fan_width, h)
)
roundbox = (box.edges("|Z").fillet(fillet_radius))
holeybox = (
    roundbox.faces(">Z")
    .workplane()
    .rect(fan_hole_spacing, fan_hole_spacing, forConstruction=True)
    .vertices()
    .hole(screw_diameter, 99)
)

inner_width = fan_width - 2 * fan_wall_thickness
leg = sqrt((fan_front_od/2)**2 - (inner_width/2)**2)
result = (
    holeybox.faces(">Z")
    .workplane()
    .moveTo(inner_width/2, 0)
    .vLineTo(leg)
    .radiusArc((leg, inner_width/2), -fan_front_od/2)
    .hLineTo(0)
    .mirrorX()
    .mirrorY()
    .wire()
    .cutThruAll()
)

show_object(result)
