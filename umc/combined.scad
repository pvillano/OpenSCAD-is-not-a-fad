$fa = .01;
$fs = $preview ? 10 : .1;


slop = .2;
thickness = 10;
height=200;
skale = height/140;

plus = $preview || true;
fire = $preview || true;

if(plus)
    color("black")
    linear_extrude(thickness)
    scale(skale)
    import("cross-only.svg");
    
if(fire)
    color("red") linear_extrude(thickness){
    difference(){
        scale(skale)
            import("fire-only.svg");
        offset(r=slop)
            scale(skale)
            import("cross-only.svg");
    }
}