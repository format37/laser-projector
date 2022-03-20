resolution = 300;
mirror_bias = -8;
mirror_h = 17;
mirror_w = 22;
wall_width=3;
draw_samples = false;
beam_alpha = 0.3;

mainframe_width = 10;
mainframe_holes_dia = 3.2;
motor_height = 0;
mainframe_r = 100;
mirror_ring_inner_r = 37;
mirror_ring_outer_r = mirror_ring_inner_r+10;


// Frame ring
rotate([0,0,30])
translate([0,0,-10])
difference()
{
    cylinder(r=mirror_ring_outer_r,h=wall_width, $fn=resolution);
    cylinder(r=mirror_ring_inner_r,h=wall_width, $fn=resolution);
    main_frame_holes();
}

// mirror support frame
translate([66,37,-7.5])
rotate([0,0,70])
cube([130,40,wall_width+2],center = true);

// Mirrors
hx = 1500; // distance to the wall in millimeters
points = [
    [0,0],
    [10,0],
    [20,0],
    [0,10],
    [0,20],
    [0,30],
    [0,40],
    [0,50],
    [-10,0],
    [-20,0],
    ];

if (draw_samples) draw_points(hx,points,10);

for (i = [0:len(points)-1])
{
    r = 40+i*10;
    circle_angle = i*10-pow(i,1.7);
    echo(circle_angle, circle_angle-pow(i,1.8));
    x_source = points[i][0];
    y_source = points[i][1];
    angle_source = y_source==0 ? 0 : atan(-y_source/x_source);
    
    
    xy_hypo = sqrt(pow(x_source,2)+pow(y_source,2));
    r180 = x_source>0 ? 0 : 1;
    
    x = i==0 ? x_source : xy_hypo*cos((angle_source-circle_angle)+180*r180);
    y = i==0 ? y_source : xy_hypo*sin((angle_source-circle_angle)+180*r180);
    
    direction = r>x ? 1 : -1;
    a = r==x ? 0 : atan(abs(r-x)/hx)*direction; //beam angle x
    
    c = y==0 ? 0 : atan(y/hx); //beam angle y    
    
    rotate([0,0,circle_angle])
    mirror_cube(a,c,0,r,circle_angle, mirror_bias, mirror_h,mirror_w);
    
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

module mirror_cube(a, c, round_bias, radius_bias, circle_angle, mirror_bias, mirror_h, mirror_w)
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
                    translate([0,mirror_bias,0]) rotate([0,-45,0]) cube([mirror_h,mirror_w,2], center=true);
                    
                    translate([0,mirror_bias,0])
                    rotate([0,-45,0])
                    translate([-mirror_h/2+1,0,2])
                    cube([2,mirror_w,4], center=true);
                }
            }
            else
            {
                rotate([0,-a/2,0])
                rotate([-c/2,0,0])            
                {
                    translate([0,mirror_bias,0]) rotate([0,-45,0]) cube([mirror_h,mirror_w,2], center=true);
                    translate([0,0,2]) cube([mirror_h,2,6], center=true);
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

module main_frame_holes()
{
    for (i = [0:2]) rotate([0,0,i*360/3])
    translate([0,-10/2,0])
    for (i = [0:mainframe_r/10-3])
    {
        //color("red")
        translate([20+i*10,mainframe_width/2,0])
        cylinder(d=mainframe_holes_dia, h=motor_height+wall_width, $fn=resolution);
    }
}