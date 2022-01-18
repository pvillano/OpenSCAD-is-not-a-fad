iw = 78;
id = 35;
ih = 16;
ep = .1;
slop=.2;
twt = .86;
twt3 = [twt,twt,twt];
inner1 = [iw+2*slop,id+2*slop,ih+twt+2*slop+ep];
outer1 = inner1 + [2*twt,2*twt, twt-ep];
inner2 = outer1 + [2*slop, 2*slop, slop];
outer2 = inner2 + [2*twt,2*twt, twt-ep];
difference(){
	cube(outer1);
	translate([twt,twt,twt]) cube(inner1);
}


translate([-outer2[0]-3,0,0]) difference(){
	cube(outer2);
	translate([twt,twt,twt]) cube(inner2);
	
	translate([outer2[0],outer2[1], 0]/2)
		mirror([1,0,0])
		linear_extrude(twt/2,center=true)
		text("Erik Simon", 12, halign="center", valign= "center");
}