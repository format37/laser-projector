
mainframe_holes_dia = 3.4;
wall_width=2;
resolution = 300;
mainframe_r = 153;
inner_hole_r = 95;
wall_bias = 5;
wall_h = 60;
bottom_connector_l = 25;

difference()
{
    cylinder(r = mainframe_r+wall_width+wall_bias, h=wall_h,$fn=resolution,center = true);
    translate([0,0,wall_width])
    
    cylinder(r = mainframe_r+wall_bias, h=wall_h,$fn=resolution,center = true);
    cylinder(r = inner_hole_r, h=wall_h*1.1,$fn=resolution,center = true);
    
    main_frame_holes();
    
    rotocropper(-10, (mainframe_r+wall_bias)*1.1);
    rotocropper(0, mainframe_r+wall_bias);
    
    for (i=[0:1])
    translate([0,0,i*20])
    {
        side_hole(mainframe_holes_dia);
        rotate([0,0,-360/3])
        side_hole(4);
    }
}

module side_hole(d)
{
    rotate([0,90,0])
    cylinder(d = d, h = mainframe_r*3, $fn = resolution, center = true);
}

module rotocropper(appendix, r)
{
    rotate([0,0,3])
    rotate_extrude(angle = 360/3+360/3+appendix, convexity = 10, $fn=resolution) 
    translate([0,-wall_h*1.1/2,0])
    square([r,wall_h*1.1]);
}

module main_frame_holes()
{
    for (j = [0:mainframe_r/10])
    {
        translate([j*10,0,0])
        cylinder(d=mainframe_holes_dia, h=wall_h*1.1, $fn=resolution, center = true);
    }
}