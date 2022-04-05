resolution = 300;
mainframe_holes_dia = 3.3;
frame_r_in = 18;
frame_r_out = 22;
frame_length = 100;

difference()
{
    cylinder(r=frame_r_out,h=frame_length,$fn=resolution, center = true);
    cylinder(r=frame_r_in,h=frame_length*1.1,$fn=resolution, center = true);
    main_frame_holes();    
    rotate([180,0,0])
    main_frame_holes();
    
    for (j = [0:4])
    translate([0,0,frame_length/2-15-18*j])
    for (i = [0:2]) rotate([0,0,i*360/3])
    translate([20,0,0])
    //cube([30,10,10],center = true);
    rotate([0,90,0])
    cylinder(d=12,h=30,$fn=resolution, center = true);
}



module main_frame_holes()
{
    for (i = [0:2]) rotate([0,0,i*360/3])
    for (j = [0:2])
    {
        translate([j*10,0,frame_length/2])
        cylinder(d=mainframe_holes_dia, h=70, $fn=resolution, center = true);
    }
}
