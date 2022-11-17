/*

# Part 1: discovery
to maximize air flow
I need to minimize resistance
while retaining a minimum dwell time
which just means using all my filter media
which has a constant volume V = Area * Thickness

# Part 2: Equations

dwell time = thickness / linear velocity
linear velocity = volume flow rate / Area

dwell time = thickness / (volume flow rate / area)
           = volume / volume flow rate (oh wait duh)

volume flow rate ~~ Pslope * (Static Pressure - pressure drop)  (I know this experimentally)
pressure drop ~~ Unkonwn * thickness/area     (also depends on velocity)


dwell time = volume / (Pslope * (Static Pressure - pressure drop))
           = volume / (Pslope * (Static Pressure - unknown * thickness/area))

wait no we were looking for volume flow rate as a function of aspect ratio

volume flow rate ~~ (Static Pressure - pressure drop)
                 ~~ (Static Pressure - ...
(I got confused)

# Part 3: reframing

A fan has two intrinsic properties, max unobstructed flow and max static pressure
This is similar to a battery's short circuit current and voltage
max unobstructed flow is really more like max static pressure / resistance

I'll start by  this like V=iR, then rearranging until volume flow rate is on the left
    Static Pressure = volume flow rate * (Resistance of Fan + Resistance of Filter)
    ==>  volume flow rate = Static Pressure / (Resistance of Fan + Resistance of Filter)
    ==>  volume flow rate = Static Pressure / (Resistance of Fan + Resistivity of Filter Media * Thickness / Area)

Then we define dwell time, then follow definitions until we have our base constants
    dwell time = thickness / linear velocity
               = thickness / (volume flow rate / area)
               = thickness * area / (volume flow rate)
               = volume / volume flow rate
This checks out: dwell time is like the inverse of how often the whole volume gets replaced

We want to be above a minimum dwell time, which we can represent with an inequality:
    actual dwell time >= safe dwell time
    ==> volume / volume flow rate  >= safe dwell time
    ==> volume / safe dwell time >= volume flow rate
    ==> volume flow rate =< volume / safe dwell time
which makes sense: a longer dwell time would require a slower flow rate
now we can combine both equations for volume flow rate
    Static Pressure / (Resistance of Fan + Resistivity of Filter Media * Thickness / Area) =< volume / safe dwell time
    ==> static pressure * safe dwell time =< volume * (Resistance of Fan + Resistivity of Filter Media * Thickness / Area)
    ==> static pressure * safe dwell time =< volume * Resistance of Fan + volume * Resistivity of Filter Media * Thickness / Area
    ==> static pressure * safe dwell time =< volume * Resistance of Fan + Resistivity of Filter Media * Thickness^2
    ==> thickness >= sqrt( (static pressure * safe dwell time - volume * Resistance of Fan) / resistivity of filter media)
which answers the question "what should the thickness be if I use all my pellets"

# Part 4: Getting an intuition because I don't have numbers anyway

It would be useful to have dwell time alone on the left to see what happens as I poke and prod
    dwell time = volume / volume flow rate
               = volume / (Static Pressure / (Resistance of Fan + Resistivity of Filter Media * Thickness / Area))
               = volume * (Resistance of Fan + Resistivity of Filter Media * Thickness / Area) / Static Pressure
However the fan doesn't have a constant internal resistance and I'm not sure V=iR for filter media either

# Wait actually

To find the steady state its as simple as overlapping two graphs
1. the flow vs pressure drop graph from the spec sheet
2. the pressure "force" vs flow graph for the filter

the "resistivity of carbon" is a function f(area, thickness, flow) -> pressure drop

dwell time = thickness * area / volume flow rate

 */




//anyway

// from http://gdstime.com/product/?99_543.html
fan_hole_spacing = 71.5;
fan_width = 80.0;
fan_thickness = 38;
fan_wall_thickness = 2.0;
screw_diameter=4.0;
nut_waf=7;
nut_h=3;
//measured
fan_back_od = 82.42;
fan_front_od = 83.72;
fan_back_id = 45.5 ;
fan_front_id = 40;

module fustrum(t=0,ep=0){
    w1=120+2*t;
    w2=fan_width+2*t;
    dh=w1-w2;
    hull(){
        translate([-w1/2,-w1/2,-t]) cube([w1,w1, 20+t]);
        translate([-w2/2,-w2/2,0]) cube([w2,w2,20+dh]);
    }
    translate([-w2/2,-w2/2,0]) cube([w2,w2,20+dh+fan_thickness+ep]);
}

t=1.28;
w=120+2*t;
difference(){
    fustrum(t,0);
    fustrum(0,.1);
    for(i=[1:4]){
        rotate([0,0,i*90]) mirror([0,0,1]) translate([2,2,-1]) cube(120/2-4*t);
    }
}