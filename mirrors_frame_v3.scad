resolution = 30;
wall_width=3;
draw_samples = true;
beam_alpha = 0.3;

hx = 50; // distance to the wall in millimeters
points = [[60,0],[20,0]];

if (draw_samples) draw_points(hx,points,10);

for (i = [0:len(points)-1])
{
    r = 40;
    x_source = points[i][0];
    y_source = points[i][1];
    circle_angle = i*90;
    
    x = points[i][0];
    y = points[i][1];
    //x = -x_source*cos(0+circle_angle);
    //y = -x_source*sin(0+circle_angle);
    
    
    // debug ++
    if (i==1)
    {
        translate([x,y,hx])
        color("green")
        sphere(r = 10, $fn = resolution);
    }
    // debug --
    
    direction = r>x ? 1 : -1;
    a = r==x ? 0 : atan(abs(r-x)/hx)*direction; //beam angle x
    b = a/2; // mirror angle x    
    
    c = y==0 ? 0 : atan(y/hx); //beam angle y
    d = c/2;
    echo(a,b,c);    
    
    rotate([0,0,circle_angle])
    mirror_cube(45+b,d,0,r,draw_samples,circle_angle);
    
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
        translate([r,0,0])        
        rotate([-c,-a,0])
        cylinder(d=4,h=x_hypo+y_hypo, $fn=resolution);
    }
}

module mirror_cube(h_angle, v_angle, round_bias, radius_bias, draw_beam, circle_angle)
{
    rotate([0,0,round_bias])
    {
        translate([radius_bias,0,0])
        rotate([h_angle, 0, -90-v_angle])
        {
            translate([0,22/2,0]) cube([17,22,2], center=true);
            translate([0,0,2]) cube([17,2,6], center=true);
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