
twt = 1.69;
slop=.2;
ridge_x = 105.0+slop;
ridge_y = 53+slop;
ridge_z = 8.15-slop;

ridge_margin = 1.2-slop;
usb_z = 53+slop;
usb_y = 24.2+slop;
usb_x =40.5+slop;

outer_x =ridge_x + 2 * ridge_margin+2*twt;
difference() {
    cube([outer_x, ridge_y + usb_y+twt, usb_z+twt]);
    //kvm cutout
    translate([ridge_margin+twt, 0, usb_z - ridge_z+twt]) cube([ridge_x,ridge_y,ridge_z]);
    //center cutout
    translate([twt,0,twt]) cube([ridge_x + 2 * ridge_margin,ridge_y + usb_y, usb_z-ridge_z]);
    //usb
    translate([outer_x/2-usb_x/2,ridge_y,twt]) cube([usb_x, usb_y, usb_z]);
}