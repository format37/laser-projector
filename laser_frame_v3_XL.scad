side = 0;

resolution = 300;
frame_dia = 40;
ring_height = 10;
laser_dia = 27.6;
sprout_l = 50;
sprout_w = 10;
mainframe_holes_dia = 3.5;
sprout_holes_bias = 5;


direction = side ? 50 : -50;
difference()
{
    body();
    
    translate([direction,0,0])
    cube([100,100,100], center = true);
}

module body()
{
    // sprouts
    difference()
    {
        sprouts();
        sprout_holes();
        laser_body();
        side_hole();
    }
 
    // frame
    difference()
    {
        //cylinder(d = frame_dia, h = ring_height, $fn=resolution, center = true);
        cube([frame_dia,frame_dia,ring_height],center = true);
        laser_body();
        side_hole();        
    }
}

module side_hole()
{
    for (i=[0:1])
    rotate([i*180,0,0])
    translate([0,frame_dia/2-mainframe_holes_dia])
    rotate([0,90,0])
    cylinder(d=mainframe_holes_dia, h=frame_dia*1.1, $fn=resolution, center=true);
}

module laser_body()
{
    cylinder(d = laser_dia, h = ring_height*1.1, $fn=resolution, center = true);
}

module sprouts()
{
    for (i = [0:2]) rotate([0,0,i*360/3])
    translate([sprout_l/2,0,0])
    cube([sprout_l,sprout_w,ring_height], center = true);
}

module sprout_holes()
{
    for (i = [0:2]) rotate([0,0,i*360/3])
    rotate([90,0,0])
    for (j=[sprout_holes_bias:10:100])
    translate([j,0,0])
    cylinder(d=mainframe_holes_dia, h = 100, $fn=resolution, center = true);
}