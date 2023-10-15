$fa =.01;
$fs = 1;

width = 175;
length=230;
height=50;
widths = [42, 34, 25, 25, 21];
twt=1.14;
function sum(x) = x * [for(i=[1:len(x)]) 1];
function cumsum(values, zero) = [for (a = 0, b = values[0]; a < len(values); a = a + 1, b = b + (values[a] == undef?zero:values[a])) b];

max_sum_widths = width - twt * (len(widths) + 1);


if(sum(widths) > max_sum_widths){
    color("red") text("error", size=100);
} else {
    widened_widths = [for(x = widths) x * max_sum_widths/sum(widths)];

    cum_widths = cumsum(widened_widths, 0);

    offsets = [for ( i = [0:len(cum_widths)-1]) cum_widths[i] - widened_widths[i] + i * twt];
    difference(){
        translate([-twt,-twt,-twt]) cube([width, length + 2*twt, height]);
        for(i = [0:len(widened_widths)-1]){
            translate([offsets[i],0,0]) cube([widened_widths[i],length,height]);
        }
    }
}

