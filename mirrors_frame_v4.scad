resolution = 30;
wall_width=3;
draw_samples = true;
beam_alpha = 0.3;

hx = 100; // distance to the wall in millimeters
points = [
    [0,0],
    [60,-50]
    ];

if (draw_samples) draw_points(hx,points,10);

for (i = [0:len(points)-1])
{
    r = 40+i*10;
    x_source = points[i][0];
    y_source = points[i][1];
    angle_source = y_source==0 ? 0 : atan(y_source/x_source);
    circle_angle = i*10;
    
    xy_hypo = sqrt(pow(x_source,2)+pow(y_source,2));
    r180 = x_source>0 ? 0 : 1;
    
    x = i==0 ? x_source : xy_hypo*cos((angle_source-circle_angle)+180*r180);
    y = i==0 ? y_source : xy_hypo*sin((angle_source-circle_angle)+180*r180);
    
    direction = r>x ? 1 : -1;
    a = r==x ? 0 : atan(abs(r-x)/hx)*direction; //beam angle x
    
    c = y==0 ? 0 : atan(y/hx); //beam angle y    
    
    rotate([0,0,circle_angle])
    mirror_cube(a,c,0,r,circle_angle);
    
    if (draw_samples) rotate([0,0,circle_angle]) beam_sample(a,r,hx,c,x,y,circle_angle);
}

module beam_sample(a,r,hx,c,x,y,circle_angle)
{
    color("lightblue", alpha = beam_alpha)
    {
        rotate([0,90,0])
        cylinder(d=4,h=r, $fn=resolution);
        
        x_bottom = r/2;
        x_top = hx;
        x_hypo = sqrt(pow(x_bottom,2)+pow(x_top,2));        
        y_bottom = abs(y);
        y_top = hx;
        y_hypo = sqrt(pow(y_bottom,2)+pow(y_top,2));
        //a=45;
        echo("beam", c, a);
        translate([r,0,0])        
        if (abs(c)<abs(a))
        {
            rotate([-c,0,0])        
            rotate([0,-a,0])
            cylinder(d=4,h=x_hypo+y_hypo, $fn=resolution);
        }
        else
        {
            rotate([0,-a,0])
            rotate([-c,0,0])
            cylinder(d=4,h=x_hypo+y_hypo, $fn=resolution);
        }
        
    }
}

module mirror_cube(a, c, round_bias, radius_bias, circle_angle)
{
    h_angle = 0;
    v_angle = 0;
    rotate([0,0,round_bias])
    {
        translate([radius_bias,0,0])
        {
            if (abs(c)<abs(a))
            {
                rotate([-c/2,0,0])        
                rotate([0,-a/2,0])
                {
                    translate([0,0,0]) rotate([0,-45,0]) cube([17,22,2], center=true);
                    //translate([0,0,2]) cube([17,2,6], center=true);
                }
            }
            else
            {
                rotate([0,-a/2,0])
                rotate([-c/2,0,0])            
                {
                    translate([0,0,0]) rotate([0,-45,0]) cube([17,22,2], center=true);
                    //translate([0,0,2]) cube([17,2,6], center=true);
                }
            }
        }
    }
}

module draw_points(hx, points, point_r)
{
    for (i = [0:len(points)-1])
    translate([points[i][0],points[i][1],hx])
    color("brown")
    sphere(r = point_r, $fn = resolution);
}