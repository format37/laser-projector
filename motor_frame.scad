motor_dia = 27.9;
motor_height = 10;
mainframe_r = 153;
mainframe_width = 10;
mainframe_holes_dia = 3.4;
wall_width=3;
resolution = 300;
draw_samples = 0;
sprout_holes_bias = 5;

if (draw_samples)
{
translate([38,0,0])
rotate([0,0,90])
color("green", alpha=0.5)
cube([350,250,5], center = true);
}

difference()
{
    positive_objects();
    motor_body();
    main_frame_holes();
}

module sprout_holes()
{
    for (i = [0:2]) rotate([0,0,i*360/3])
    rotate([90,0,0])
    for (j=[sprout_holes_bias:10:300])
    translate([j,0,0])
    cylinder(d=mainframe_holes_dia, h = 100, $fn=resolution, center = true);
}

module positive_objects()
{
    motor_frame();
    main_frame();
}

module main_frame()
{
    difference()
    {
        color("gray")
        for (i = [0:2]) rotate([0,0,i*360/3])
        translate([mainframe_r/2,0,0])
        cube([mainframe_r,mainframe_width,motor_height+wall_width], center = true);
        sprout_holes();
    }    
}

module main_frame_holes()
{
    for (i = [0:2]) rotate([0,0,i*360/3])    
    for (j = [0:30])
    {
        translate([j*10,0,0])
        cylinder(d=mainframe_holes_dia, h=20, $fn=resolution, center = true);
    }
}

module motor_frame()
{        
    cylinder(d=motor_dia+wall_width*2,h=motor_height+wall_width, $fn=resolution, center=true);
}

module motor_body()
{
    cylinder(d=11,h=20, $fn=resolution, center = true);
    translate([0,0,-2])
    cylinder(d=motor_dia,h=motor_height+4, $fn=resolution, center = true);
}
