resolution = 300;
mainframe_holes_dia = 3.3;
frame_r_in = 18;
frame_r_out = 22;
frame_length = 100;

//18

difference()
{
    cube([50,50,38], center = true);
    main_frame_holes();
}
translate([100/2+50/2,0,0])
rotate([0,90,0])
cylinder(d=38,h=100,$fn=resolution, center= true);

module main_frame_holes()
{
    for (i = [0:2]) rotate([0,0,i*360/3])
    for (j = [2:2])
    {
        translate([j*10,0,0])
        cylinder(d=mainframe_holes_dia, h=70, $fn=resolution, center = true);
    }
}
