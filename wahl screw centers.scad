$fa=.01;
$fs=.3;

id = 3/16*25.4;
od_list= [6.8,7.1];
h=3.5;

for(i=[0,1]){
	od=od_list[i]-.1;
	translate([i*(od+6),0,0])
	difference(){
		cylinder(h=h,d=od);
		translate([0,0,-1]) cylinder(h=h+2,d=id);
	}
}