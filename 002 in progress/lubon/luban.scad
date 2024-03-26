cellHeight = 15.0 ; // top to bottom of stool
cellWidth = 20.0; // side to side of stool
cellLength = 15.0; // front to back of stool
hingeCellWidth = 40.0; // side to side of stool
pleatsCount = 7.0;
sawKerf = .6;
ep = 0 + .01;

// from https://www.youtube.com/watch?v=RdbehskY8_k

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}

module hingeTriangles(width) {
  translate([0, -cellLength * pleatsCount / 2]) for (i = [0:pleatsCount - 1]) {
    if (i % 2 == 0) {
      hull() {
        translate([-width, i * cellLength, 0]) cube([ep, cellLength, cellHeight]);
        translate([0, i * cellLength, cellHeight]) cube([ep, cellLength, ep]);
      }
    } else {
      hull() {
        translate([width, i * cellLength, 0])
          cube([ep, cellLength, cellHeight]);
        translate([0, i * cellLength, cellHeight]) cube([ep, cellLength, ep]);
      }
    }
  }
}

module hingeKerf(width) {
  translate([0, -cellLength * (pleatsCount) / 2, 0])for (i = [1:pleatsCount - 1]) {
    translate([0, i * cellLength, 0]) cube([2 * width, sawKerf, 2 * cellHeight], center = true);
  }
}

module main() {
  render() difference() {
    cube([8 * cellWidth + 2 * hingeCellWidth, pleatsCount * cellLength, 3 * cellHeight], center = true);
    // chisel out bottom of hinge
    translate([0, 0, -cellHeight]) cube([2 * hingeCellWidth, pleatsCount * cellLength, cellHeight], center = true);
    // chisel triangles in top of hinge
    translate([0, 0, cellHeight / 2]) hingeTriangles(hingeCellWidth);
    // chisel triangles in bottom of hinge
    translate([0, 0, cellHeight / 2]) rotate([0, 180, 0]) hingeTriangles(hingeCellWidth);
    //chisel feet hinges
    mirror2([1, 0, 0]) translate([hingeCellWidth + 2 * cellWidth, 0, -cellHeight / 2]) rotate([0, 180, 0])
      hingeTriangles(cellWidth);
    //saw free top hinges
    translate([0, 0, cellHeight / 2])hingeKerf(hingeCellWidth);
    // saw free top of stool
    mirror2([1, 0, 0]) translate([hingeCellWidth + 2 * cellWidth, 0, cellHeight / 2])
      cube([4 * cellWidth, pleatsCount * cellLength, sawKerf], center = true);
    // hide top of stool
    if ($preview && false) {
      translate([0, 0, cellHeight]) cube([8 * cellWidth + 2 * hingeCellWidth, pleatsCount * cellLength, cellHeight],
      center = true);
    }
    // chisel top of feet hinges
    mirror2([1,0,0]) translate([hingeCellWidth + 2 * cellWidth, 0, -cellHeight / 2])
      hingeTriangles(cellWidth);
    //saw free bottom hinges
    mirror2([1, 0, 0]) translate([2 * cellWidth + hingeCellWidth, 0, -cellHeight / 2])
      rotate([0,180,0])
      hingeKerf(cellWidth);
    //saw free legs inner
    mirror2([1, 0, 0])
      translate([hingeCellWidth + cellWidth / 2, 0, -cellHeight / 2])
      cube([cellWidth, pleatsCount * cellLength, sawKerf], center = true);
    // saw free legs outer
    mirror2([1, 0, 0])
      translate([hingeCellWidth + 3.5* cellWidth, 0, -cellHeight / 2])
      cube([cellWidth, pleatsCount * cellLength, sawKerf], center = true);
  }
}
render() difference(){
  size=8;
  main();
  translate([0,0,1.5*cellHeight-1]) linear_extrude(1){
    translate([-hingeCellWidth-3*cellWidth,0,0]) rotate([0,0,90])
      text("Peter", size, halign="center", valign="center");
    translate([-hingeCellWidth-cellWidth,-17,0]) rotate([0,0,90])
      scale(.007*size) import("link-svgrepo-com.svg", center=true);
    translate([-hingeCellWidth-cellWidth,0,0]) rotate([0,0,90])
      text("    Saej.in", size, halign="center", valign="center");
    translate([hingeCellWidth+cellWidth,0,0]) rotate([0,0,90])
      text("Villano", size, halign="center", valign="center");
    translate([hingeCellWidth+3*cellWidth,0,0]) rotate([0,0,90])
      text("Software", size, halign="center", valign="center");
  }
  translate([0,0,.5*cellHeight]) linear_extrude(1 + sawKerf/2) rotate([180,0,0]){
    translate([-hingeCellWidth-3*cellWidth,0,0]) rotate([0,0,90])
      text("AKA", size, halign="center", valign="center");
    translate([-hingeCellWidth-cellWidth,0,0]) rotate([0,0,90])
      text("Rocky", size, halign="center", valign="center");
    translate([hingeCellWidth+3*cellWidth,0,0]) rotate([0,0,90])
      scale([.8,1])rotate(180)text("Parametric", size, halign="center", valign="center");
    translate([hingeCellWidth+cellWidth,0,0]) rotate([0,0,90])
      rotate(180) text("Design", size, halign="center", valign="center");
  }
//  translate([0,0,-cellHeight]) cube([8 * cellWidth + 2 * hingeCellWidth, pleatsCount * cellLength, 3 * cellHeight], center = true);
}