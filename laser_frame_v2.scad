resolution = 300;
motor_dia = 27.5;
motor_height = 0;
mainframe_r = 100;
mainframe_width = 10;
mainframe_holes_dia = 3;
wall_width=5;
bottom_ring_inner_dia = 50;
bottom_ring_outer_dia = 70;
tower_height = 60;
column_rotation_bias = 360/3/2;
tower_hole_angle = 105;
laser_dia = 8;

difference()
{
    bottom_frame();
    outer_crop_ring();
    inner_crop_ring();
}

//difference()
difference()
{
    tower();
    //tower_cropper();
    cylinder(d=laser_dia, h = tower_height*3, $fn=resolution);
}

/*module tower_cropper()
{
    //color("blue")
    difference()
    {
        for (j = [0:3]) rotate([0,0,j*360/3])
        {
            rotate([0,0,-tower_hole_angle/2])
            translate([0,0,wall_width])
            rotate_extrude(angle = tower_hole_angle, convexity = 10) cropper_square();
        }
        cylinder(d=bottom_ring_inner_dia, h = tower_height*3);
    }
}

module cropper_square()
{
    square([40,tower_height*2]);
}*/

module tower()
{
    difference()
    {    
        translate([0,0,tower_height-laser_dia/2+1])
        //sphere(d=bottom_ring_outer_dia, $fn=resolution);
        cylinder(d=bottom_ring_inner_dia+2, h=laser_dia, $fn=resolution);
        
        //translate([0,0,tower_height-wall_width*2])
        //sphere(d=bottom_ring_outer_dia, $fn=resolution);
    }
    
    //column
    column_side = (bottom_ring_outer_dia-bottom_ring_inner_dia)/2;
    for (i = [0:2]) rotate([0,0,i*360/3+column_rotation_bias])
    translate([(bottom_ring_outer_dia/2+bottom_ring_inner_dia/2)/2,0,tower_height/2+wall_width]) //translate([(bottom_ring_outer_dia/2+bottom_ring_inner_dia/2)/2,0,tower_height/2+wall_width+bottom_ring_outer_dia/4])
    cube([column_side,column_side,tower_height], center = true);
}

module bottom_frame()
{
    // main frame connector
    for (i = [0:2]) rotate([0,0,i*360/3]) main_frame();
    difference()
    {
        main_frame();
        main_frame_holes();    
    }
    bottom_ring();
}

module inner_crop_ring()
{
    cylinder(d=motor_dia+wall_width+3, h=wall_width, $fn=resolution);
}

module outer_crop_ring()
{
    difference()
    {
        cylinder(d=mainframe_r*3, h=wall_width, $fn=resolution);
        cylinder(d=bottom_ring_outer_dia, h=wall_width, $fn=resolution);
    }
}

module bottom_ring()
{    
    difference()
    {
        cylinder(d=bottom_ring_outer_dia, h=wall_width, $fn=resolution);
        cylinder(d=bottom_ring_inner_dia, h=wall_width, $fn=resolution);
    }
}

module main_frame()
{
    translate([0,-10/2,0]) // to center
    difference()
    {
        //color("blue")
        cube([mainframe_r,mainframe_width,motor_height+wall_width]);
        main_frame_holes();
    }    
}

module main_frame_holes()
{
    for (i = [0:mainframe_r/10-3])
    {
        //color("red")
        translate([20+i*10,mainframe_width/2,0])
        cylinder(d=mainframe_holes_dia, h=motor_height+wall_width, $fn=resolution);
    }
}
