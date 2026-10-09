/*

todo: parameterize module spring
create sector utility function
print a grid of different parameters

for x, y angle, height
    sweep percent_filled, turns
*/



module sector2d(angle, radius){
    
}

a=30;

module spring(percent_filled, height, turns, id, od){
    linear_extrude(height=20, twist=360*3){
        difference(){
            circle(10);
            circle(7);
            intersection(){
                rotate(0) square(10);
                rotate(90-a) square(10);
            }
            intersection(){
                rotate(180) square(10);
                rotate(270-a) square(10);
            }
        }
    }
}