// Change this next line for the diameter of your lens cap.
lens_diameter = 77;       // outer diameter of cap
// Change the next line for the width of your strap.
buckle_width = 40;	      // strap width

mount_height = 1.0;         // height of lip
mount_width = 4;          // width of ring
mount_base = 3;           // height of buckle
mount_lip_height = 0.2;   // lip tip height (to help secure cap)
mount_lip_width = 0.37;    // width of lip tip (to help secure cap)
mount_lip_spacing = 0.8;  // distance between "threads"
mount_lip_count = 3;  // number of "threads," or lips, to include

buckle_gap = 6;           // gap for strap
buckle_thickness = 6;     // thickness of buckle
buckle_split = 5;         // split buckle if you can't thread it through

filled_buckle = false;    // fill the buckle center?

$fa = .01;
$fs = 1;

union()
{
	// Subtract 0.5mm for a tight fit	
	buckle(lens_diameter-0.5);
	capmount(lens_diameter-0.5);
	//capmount(57.5); // Uncomment this line and change the diameter to create a second concentric ring for smaller caps
}

module capmount(lens_size)
{
	
    lip_height = mount_base + mount_height;
	total_lip_height = mount_lip_height + mount_lip_spacing;
	loop_lip_height = 0;

    cap_outer = lens_size/2 + mount_width;
    cap_inner = lens_size/2 - mount_width;

    union()
    {
        // the base of the lens cap mount
        linear_extrude(height=mount_base) difference()
        {
            circle(cap_outer);
            if (!filled_buckle) circle(cap_inner);
        }

        // generate extra base support if it's not filled
        if (!filled_buckle) for(i=[-45,45])
            linear_extrude(height=mount_base) rotate(i)
                square([lens_size, mount_width], center=true);

        // generate the cap friction mount and extra securing lip
		for ( ctr = [0:mount_lip_count-1] ) 
		{
			assign(loop_lip_height = lip_height + ctr*total_lip_height - loop_lip_height)
	        difference()
	        {
	            linear_extrude(height=loop_lip_height) 
	                circle(cap_outer);
	            linear_extrude(height=loop_lip_height) 
	                circle(lens_size/2 - mount_lip_width);
	            linear_extrude(height=loop_lip_height - mount_lip_height) 
	                circle(lens_size/2);
	        }
		}
    }
}

module buckle(lens_size)
{
    buckle_inner = lens_size/2 + mount_width + buckle_gap;
    buckle_outer = buckle_inner + buckle_thickness;

    squared_inner = buckle_width;
    squared_outer = buckle_width + 2*buckle_thickness;

    squared_offset = sqrt(pow(buckle_outer,2) - pow(squared_outer/2,2));

    rotate(a=[0,0,90]) {
		linear_extrude(height=mount_base) union()
	    {
	        // the arc portion of the buckle
	        intersection()
	        {
	            square([buckle_outer*4, squared_outer], center=true);
	            difference()
	            {
	                circle(buckle_outer);
	                circle(buckle_inner);
	
	                if (buckle_split > 0)
	                    square([buckle_outer*4, buckle_split], center=true);
	            }
	        }
	
	        // the squared-length portion of the buckle
	        difference()
	        {
	            square([squared_offset*2, squared_outer], center=true);
	            square([squared_offset*2, squared_inner], center=true);
	        }
	    }
	}
}