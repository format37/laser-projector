motor_dia = 27.5;
motor_height = 10;
mainframe_r = 100;
mainframe_width = 10;
mainframe_holes_dia = 3;
wall_width=3;
resolution = 300;

difference()
{
    positive_objects();
    motor_body();    
}

module positive_objects()
{
    motor_frame();
    
    for (i = [0:2]) rotate([0,0,i*360/3]) main_frame();
}

module main_frame()
{
    translate([0,-10/2,0]) // to center
    difference()
    {
        color("blue")
        cube([mainframe_r,mainframe_width,motor_height+wall_width]);
        main_frame_holes();
    }    
}

module main_frame_holes()
{
    for (i = [0:mainframe_r/10-3])
    {
        color("red")
        translate([20+i*10,mainframe_width/2,0])
        cylinder(d=mainframe_holes_dia, h=motor_height+wall_width, $fn=resolution);
    }
}

module motor_frame()
{        
    cylinder(d=motor_dia+wall_width*2,h=motor_height+wall_width, $fn=resolution);
}

module motor_body()
{
    cylinder(d=10,h=20, $fn=resolution);
    cylinder(d=motor_dia,h=motor_height, $fn=resolution);
}
