// Model from https://www.printables.com/model/1379369-gridfinity-608-bearing-holder-22-bearings-easy-pri
h_original = 31.4;
h_desired = 34.9;

module original() {
  translate([-83.2, -388, -17])import("gridfinity-806-22-brearings-holder_base_easy_print.stl");
}

module elongate(cut_height = 10, dh = 1, bboxXYZ = [-250, -250, -250], bboxLWH = [500, 500, 500]) union(){
  //bottom
  render()intersection() {
    children();
    translate(bboxXYZ) cube([bboxLWH.x, bboxLWH.y, -bboxXYZ.z + cut_height]);
  }
  //midsection
  translate([0, 0, cut_height])linear_extrude(dh) projection(true)translate([0, 0, -cut_height]) children();
  //top
  render() translate([0,0,dh]) intersection() {
    children();
    translate([bboxXYZ.x, bboxXYZ.y, cut_height]) cube([bboxLWH.x, bboxLWH.y, bboxLWH.z - cut_height + bboxXYZ.z]);
  }
}
//projection(true) translate([0,0,-45])
//elongate(27, h_desired-h_original) original();
elongate(5.8, h_desired-h_original) original();

//projection(true)translate([0,0,-5.8])original();
