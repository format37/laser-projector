points = [
    [0,250],//
    [0,500],//
    [250,500],//
    [500,500],//
    [-250,500],//
    [-500,500],//
    [-750,500],//
    [-1000,250],//
    [-1000,0],//
    [750,500],//
    [0,250],//
    [0,500],//
    [250,500],//
    [500,500],//
    [-250,500],//
    [-500,500],//
    [-750,500],//
    [-1000,250],//
    [-1000,0],//
    [750,500],//
    [0,-250],//
    [0,-500],//
    [250,-500],//
    [500,-500],//
    [-250,-500],//
    [-500,-500],//
    [-750,-500],//
    [-1000,-250],//
    [750,-500],//
    [0,0],//
    [0,-250],//
    [0,-500],//
    [250,-500],//
    [500,-500],//
    [-250,-500],//
    [-500,-500],//
    [-750,-500],//
    [-1000,-250],//
    [750,-500],//1
    [0,0],//*/
];

lighted_point = 1-1;
hx = 4500; // distance to the wall in millimeters
draw_samples = 0;
draw_samples_p = 0;
draw_samples_l = 0;

split_frame = 0;

// Python empty point generator
//for i in range(52):
//    print('    [0,0],')

resolution = 300;
mirror_bias = 0;
mirror_h = 10;
mirror_w = 10;
wall_width=3;
beam_alpha = 0.3;
mirror_frame_len = 25;
mirror_frame_in_r=90;
mirror_frame_out_r=mirror_frame_in_r+15;
pi = 3.1415926535897932384626433832795;
frame_connector_angle = 00;
main_frame_h_bias = -8.5;

mainframe_width = 10;
mainframe_heigth = 5;
mainframe_holes_dia = 3.4;

ang = 2;

// debug ++
/*color("red")
translate([mirror_frame_in_r,-5,-3.6])
rotate([0,45,0])
cube([0.1,10,10]);*/
// debug --

if (split_frame) difference()
{
    body();
    rotate([0,0,56+360*ang/3])
    rotate_extrude(angle = 360/3+360/3, convexity = 10, $fn=resolution) 
    translate([0,-200/2,0])
    square([200,200]);
}
else body();

//rotate([0,0,frame_connector_angle])
//main_frame_holes();

module body()
{
    if (split_frame)
    {
        // Frame outer connectors
        rotate([0,0,frame_connector_angle])
        for (i=[0:2])
        rotate([0,0,i*360/3-4])
        translate([mirror_frame_out_r-1,0,main_frame_h_bias])
        difference()
        {
            cube([10,10,mainframe_heigth], center = true);
            rotate([90,0,0])
            cylinder(d=mainframe_holes_dia, h=20, $fn=resolution, center = true);
        }
    }


    //Frame Ring
    translate([0,0,main_frame_h_bias])
    difference()
    {
        cylinder(r=mirror_frame_out_r-5,h=mainframe_heigth, $fn=resolution, center = true);
        cylinder(r=mirror_frame_in_r-5,h=mainframe_heigth*1.1, $fn=resolution, center = true);
    }



    // Frame base
    rotate([0,0,frame_connector_angle])
    for (i=[0:2])
    rotate([0,0,i*360/3])
    translate([0,0,main_frame_h_bias])
    difference()
    {
        mirror_frame();
        main_frame_holes();
    }

    // mirror support frame
    //translate([66,37,-7.5])
    //rotate([0,0,70])
    //cube([130,40,wall_width+2],center = true);

    // Mirrors
    if (draw_samples_l) draw_lines(hx, points, 5);

    if (draw_samples_p) draw_points(hx,points,50);

    for (i = [0:len(points)-1])
    {
        r = mirror_frame_in_r+(mirror_frame_out_r-mirror_frame_in_r)/2;
        d_between_mirrors = 2*pi*r;
        circle_angle = (i*360/len(points));
        x_source = points[i][0];
        y_source = points[i][1];
        angle_source = y_source==0 ? 0 : atan(y_source/x_source);
        
        
        xy_hypo = sqrt(pow(x_source,2)+pow(y_source,2));
        r180 = x_source>0 ? 0 : 1;
        
        x = i==0 ? x_source : xy_hypo*cos((angle_source-circle_angle)+180*r180);
        y = i==0 ? y_source : xy_hypo*sin((angle_source-circle_angle)+180*r180);
        
        direction = r>x ? 1 : -1;
        a = r==x ? 0 : atan(abs(r-x)/hx)*direction; //beam angle x
        
        c = y==0 ? 0 : atan(y/hx); //beam angle y    
        
        rotate([0,0,circle_angle]) flow_entity(a/2+45,r,hx,c*2,x,y,circle_angle, "mirror");
        if (draw_samples) rotate([0,0,circle_angle]) flow_entity(a,r,hx,c,x,y,circle_angle, "beam");
    }
}

module mirror_frame()
{
    difference()
    {
        translate([mirror_frame_in_r-mirror_frame_len/2,0,0])
        cube([mirror_frame_len,mainframe_width,mainframe_heigth], center = true);
        cylinder(d=mirror_frame_in_r-mirror_frame_len,h=40,$fn=resolution,center=true);
    }
}

module draw_lines(hx, points, point_r)
{   
    //line_length
    r = mirror_frame_in_r+(mirror_frame_out_r-mirror_frame_in_r)/2;
    a = atan(mirror_w/2/r);
    a_rad = a*pi/180;
    //p = tan(a_rad)*hx;
    echo("CHECK IS THIS EQUAL");
    echo("math.tan(",a_rad,")*",hx);
    p = 264.70577977848416;
    echo(p);    
    //echo(hx,a_rad, p, tan(a_rad), sin(a_rad)/cos(a_rad));    
    
    for (i = [0:len(points)-1])
    {   
        //draw line
        circle_angle = (i*360/len(points));
        translate([points[i][0],points[i][1],hx])        
        rotate([0,0,circle_angle])
        if (i==lighted_point)
            color("red")
            cube([point_r,p*2+mirror_w,point_r], center = true);
        else
            color("green")
            cube([point_r,p*2+mirror_w,point_r], center = true);
    }
}

module draw_entity(x_hypo, y_hypo, entity)
{
    if (entity == "mirror") mirror_holder();
    else 
        color("lightblue", alpha = beam_alpha)
        cylinder(d=4,h=x_hypo+y_hypo, $fn=resolution);
}

module flow_entity(a,r,hx,c,x,y,circle_angle, entity)
{    
    {
        if (draw_samples)
            color("lightblue", alpha = beam_alpha)
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
            draw_entity(x_hypo, y_hypo, entity);
        }
        else
        {
            rotate([0,-a,0])
            rotate([-c,0,0])                        
            draw_entity(x_hypo, y_hypo, entity);
        }
    }
}

module mirror_holder()
{
    mirror_place_thicnkess = 6;
    
    holder_tri_thickness = 0.8; 
    mirror_depth = 3.9;   

    translate([0,0,-mirror_place_thicnkess/2])
    cube([mirror_h+3,mirror_w+3,mirror_place_thicnkess], center=true);

    if (draw_samples) {
        color("lightblue", alpha = 0.5)
        translate([0,mirror_bias,mirror_depth/2])
        //translate([0,0,mirror_depth/2+mirror_place_thicnkess/2])
        cube([mirror_h,mirror_w,mirror_depth], center=true);
    }

    mirror_side_holder(holder_tri_thickness, mirror_h, mirror_depth, mirror_depth);
    rotate([180,180,0])
    mirror_side_holder(holder_tri_thickness, mirror_h, mirror_depth, mirror_depth);
    
    if (draw_samples) cylinder(d=1,h=200,$fn=resolution, center = true);
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
    //echo();
    for (i = [0:2]) rotate([0,0,i*360/3])    
    for (i = [0:30])
    {
        translate([i*10,0,0])
        cylinder(d=mainframe_holes_dia, h=10, $fn=resolution, center = true);
    }
}

module mirror_side_holder(holder_tri_thickness, mirror_h, mirror_depth, mirror_place_thicnkess)
{
    mirror_holder_tri_b_addiction = 0.4;
    holder_tri_d = mirror_place_thicnkess+mirror_depth;
    translate([0,mirror_w*0.5,mirror_place_thicnkess/2])
    rotate([90,0,90])
    //translate([mirror_holder_tri_b_addiction,holder_tri_d/2-mirror_place_thicnkess/2,0])
    translate([mirror_holder_tri_b_addiction,holder_tri_d/2-mirror_place_thicnkess,0])
    rotate([0,0,10])
    cube([holder_tri_thickness,holder_tri_d,mirror_h], center=true);
}