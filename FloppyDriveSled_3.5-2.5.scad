$fa = .01;
$fs = $preview ? 1 : .1;

inch=25.4;

twt=.86;
twt2=.454;
// Overall Outter frame dimensions.  Should match that of 5.25" drive 
height = 24;
width = 4*inch;
depth = 95;

//  Settings for internal size.  Should fit a 3.5" HDD
Iwidth = 2.75*inch+.2;
BedThickness = twt;
WallThickness = twt;

// Settings for the depth of the outter screw holes.
OSDepth1 = 11.5;
OSDepth2 = OSDepth1 + 30;
OSHeight1 = 6.35;
OSDiamater = 4;

// Settings for the bottom screw holes of sled
BOSDepth1 = 24.28;
BOSDepth2 = BOSDepth1 + 44.45;


// Inner screw nibs
HDDepth1 = 10;
HDDepth2 = HDDepth1 + 76.6;
HDHeight = (BedThickness + height)/2;
NubLength = 1;
NubWidth = 2;


difference(){
    //outer
    cube([width,depth,height], center=true);
    //void
    cube([width-2*twt,depth+.2,height-2*twt], center=true);
    cube([Iwidth,depth+.2,height-(2*twt2)], center=true);
    //slots
    for(i=[-2:2]) hull(){
        dy=i*15;
        translate([0,dy,0])
            rotate([0,90,0])
            rotate([0,0,360/16])
            cylinder(h=width+.2,d=OSDiamater,center=true, $fn=8);
        translate([0,dy,-(height/2-twt-OSDiamater/2)])
            rotate([0,90,0])
            rotate([0,0,360/16])
            cylinder(h=width+.2,d=OSDiamater,center=true, $fn=8);
    }
}
for(i=[-1,1])
    translate([i*(Iwidth/2+twt2/2),0,0])
    cube([twt2,depth,height],center=true);

//nubs
for(i=[-1,1], dy=[depth/2-HDDepth1,depth/2-HDDepth2])
    translate([i*Iwidth/2,dy,0])
    rotate([0,-90*i,0])
    cylinder(h=NubLength, d=NubWidth);