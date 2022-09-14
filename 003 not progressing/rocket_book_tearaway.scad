IN2MM = 25.4;

height = 8.75* IN2MM;
width = 6 * IN2MM;
thickness = 3;
pen_r = 3.6 / PI / 2;
n_holes = 35;

hole_percent = .6;

spacing = height / (n_holes + 1 - hole_percent);

hole_d = hole_percent * spacing;

union() {
    cube([width, height, thickness]);

    translate() {
        difference() {
            
            
            
        }
    }
}
