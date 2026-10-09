sheet_thickness = .4; // [0:.05:2]
interface_thickness = .2; // [0:.05:2]
size = [50,70];
width = 10;
number_of_layers = 10;
//mounting=false
module chamfkowski(delta){

}
//%linear_extrude(sheet_thickness) square(size, center=true);


ep=.1;
module layer(even=true)
linear_extrude(sheet_thickness)
difference(){
  delta=width*(1+1/sqrt(2));
  offset(delta=delta, chamfer=true) offset(-delta) square(size, center=true);
  if(even){
    offset(delta=-width) square(size + [0,2*width+ep], center=true);
  } else {
    offset(delta=-width) square(size + [2*width+ep,0], center=true);
  }
}


//sheets
for(i=[0:number_of_layers-1]){
  translate([0,0,i*(sheet_thickness+interface_thickness)]){
    layer(floor(i/2)%2==0);
  }
}
//corner connectors
#for(i=[1:2:number_of_layers-2]){
  translate([0,0,i*(sheet_thickness+interface_thickness) + sheet_thickness/2]){
    linear_extrude(interface_thickness+sheet_thickness)
    difference() {
      delta = width * (1 + 1 / sqrt(2));
      offset(delta = delta, chamfer = true) offset(-delta) square(size, center = true);
      offset(delta = delta-sheet_thickness, chamfer = true) offset(-delta) square(size, center = true);
      offset(delta=-width) square(size + [0,2*width+ep], center=true);
      offset(delta=-width) square(size + [2*width+ep,0], center=true);
    }
  }
}

//outside edge connectors
//inside edge connectors
