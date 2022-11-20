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
screw_diameter = 4.1;
nut_waf = 7.1;
nut_h = 3.2;
//measured
fan_back_od = 82.42;
fan_front_od = 83.72;
fan_back_id = 45.5 ;
fan_front_id = 40;

grille_diameter = 30.12;
grille_thickness = 1.69;

filter_width = 120;
$fa=.1;
$fs=1;

module fan() {
    fan_width2 = fan_width - 2 * fan_wall_thickness;
    difference() {
        cube([fan_width, fan_width, fan_thickness], center = true);
        intersection() {
            cylinder(d1 = fan_front_od, d2 = fan_back_od, h = fan_thickness + .2, center = true);
            cube([fan_width2, fan_width2, fan_thickness + .2], center = true);
        }
        for (i = [- 1, 1], j = [- 1, 1]) {
            translate([fan_hole_spacing / 2 * i, fan_hole_spacing / 2 * j, 0])
                cylinder(d = screw_diameter, h = fan_thickness + .2, center = true);
        }
    }
    color("red")cylinder(d1=10,d2=0,h=10);
}

module nose_cone(d, h = 0) {
    h_real = h == 0 ? d : h;
    difference() {
        intersection() {
            cylinder(d = d * 2, h = h_real, $fn = 3);
            scale([1, 1, h_real / d * 2])sphere(d = d);
        }
    }
}

module front_cone() {
    difference() {
        grille_offset = 5.7;
        nose_cone(fan_front_id);
        cylinder(d = grille_diameter, h = grille_offset, center = true);
        cube([grille_thickness, fan_front_id + .2, grille_offset], center = true);
        cube([fan_front_id + .2, grille_thickness, grille_offset], center = true);
    }
}

height = 40;
filter_margin = 7;
wall_thickness = 1.28;
nut_wav=nut_waf*2/sqrt(3);
fan_width_inner = fan_width - 2 * fan_wall_thickness;
filter_width_inner = filter_width - 2 * filter_margin;
filter_width_outer = filter_width + 2 * wall_thickness;
filter_od = (filter_width - filter_margin) * fan_back_od / fan_width_inner;
translate([0, 0, height]) {
    %translate([0, 0, fan_thickness / 2]) fan();
//    translate([0, 0, fan_thickness]) front_cone();
}

difference(){
    hull(){
        translate([0,0,height/2]) cube([fan_width,fan_width,height], center=true);
        translate([0,0,.1])cube([filter_width_outer,filter_width_outer,.1], center=true);
    }
    //internal cavity
    hull(){
        translate([0,0,height])intersection(){
            cylinder(d = fan_back_od, h=.2, center=true);
            cube([fan_width_inner,fan_width_inner,.2], center=true);
        }
        intersection(){
            cylinder(d = filter_od, h=.2, center=true);
            cube([filter_width_inner,filter_width_inner,.2], center=true);
        }
    }
    //bolts and nuts top
    for(i=[0:3]) rotate([0,0,i*90]){
        translate([fan_hole_spacing/2, fan_hole_spacing/2, height-10]){
            cylinder(d=screw_diameter,h=10.1);
            translate([0,0,nut_h+.35/2]) rotate([0,0,45]) #cube([screw_diameter,nut_waf,.35], center=true);
            translate([0,0,nut_h+1.5*.35]) rotate([0,0,45]) #cube([screw_diameter,screw_diameter,.35], center=true);
            rotate([0,0,45]) hull(){
                cylinder(d=nut_wav,$fn=6,h=nut_h);
                translate([-10,0,0]) cylinder(d=nut_wav,$fn=6,h=nut_h);
            }

        }
    }
    //bolts and nuts bottom
    for(i=[0:3]) rotate([0,0,i*90]){
        dx = 105/2;
        translate([dx,dx,0]) {
            rotate([0,0,45]) translate([0,0,1.7]) hull(){
                cylinder(d=nut_wav,$fn=6,h=nut_h);
                translate([-20,0,0])cylinder(d=nut_wav,$fn=6,h=nut_h);
            }
            translate([0,0,-.1]) cylinder(d=screw_diameter,h=2);
        }
    }
}

//cylinder(d2 = fan_back_od, d1 = 120, h = 40);

