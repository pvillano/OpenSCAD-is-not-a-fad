include <BOSL2/std.scad>
include <BOSL2/gears.scad>
ang=135;
t1=49;
t2=round(t1/(sqrt(2)+1));

move([0,0,10])bevel_gear(mod=3,t1,t2,ang,spiral=0,backing=5,anchor="apex")
  cyl(h=48,d=3,$fn=16,anchor=BOT);
n=5;
for(i=[0:n]) zrot(i*360/n)
color("lightblue")
xrot(ang)
  bevel_gear(mod=3,t2,t1,ang,spiral=0,right_handed=true,anchor="apex")
    cyl(h=65,d=3,$fn=16,anchor=BOT);
color("red")
xrot(180)
  bevel_gear(mod=3,t2,t1,ang,spiral=0,right_handed=true,anchor="apex")
    cyl(h=65,d=3,$fn=16,anchor=BOT);

/*
the angle of the sun, the planets, and the ring in some way have to add up to 180

*/