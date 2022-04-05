resolution = 300;
height = 60;
width = 20;
depth = 0.8;
mainframe_holes_dia = 3.4;
sprout_holes_bias = 5;
sprout_w = 10;

alpha = 9.6;


difference()
{
    composition();
    color("green")
    cube([width*10, height*2, sprout_w], center = true);
}

module composition()
{
    difference()
    {
        rotate([0,alpha,0])
        translate([4*10,0,0])
        body();
        translate([4*10,0,0])
        for (i=[0:1])
        for (j=[0:1])
        rotate([i*180,j*180,0])
        translate([10/2,height/2-10/2,0])
        cylinder(d = mainframe_holes_dia, h=sprout_w*3, $fn=resolution, center = true);
    }
}

module body()
{
    translate([0,0,-depth/2])
    cube([width, height, depth], center = true);
    translate([0,height/2-sprout_w/2,sprout_w/2])
    cube([width, sprout_w, sprout_w], center = true);
    translate([0,-height/2+sprout_w/2,sprout_w/2])
    cube([width, sprout_w, sprout_w], center = true);
}
