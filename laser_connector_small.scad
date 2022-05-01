prism_side = 15.2;
prism_bias = 2;
resolution = 300;
side = 1;

difference()
{
    main_frame_height = prism_side+2*2;
    color("green")
    translate([0,0,5/2])
    cube([30,30,main_frame_height+5], center = true);

    translate([0,prism_side,0])
    cube([30,30,main_frame_height], center = true);
    // Screws
    for (x=[-1:4])    
    for (y=[0:3])
    translate([x*(prism_side+prism_bias)-(prism_side+prism_bias)/2,y*(prism_side+prism_bias)-(prism_side+prism_bias)/2,0])
    cylinder(d=4,h=130,$fn=resolution, center = true);
    // Laser hole
    rotate([90,0,0])
    cylinder(d=8,h=130,$fn=resolution, center = true);
    // Side cropper
    translate([0,0,100/2*side])
    cube([100,100,100], center = true);
}