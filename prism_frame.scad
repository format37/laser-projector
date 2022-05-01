batch_size = 1;
prism_side = 15.2;
prism_bias = 2;
resolution = 300;
side = 1; // 1 or -1

difference()
{
    main_frame_height = prism_side+2*2;
    color("Gray")
    translate([0,15,0])
    cube([130,65,main_frame_height], center = true);
    translate([0,-2.5,0])
    prism();
    translate([0,15,main_frame_height/2*side])
    cube([130,65,main_frame_height], center = true);
}

module prism()
{
    for (level=[0:batch_size])
    {
        a = pow(level,2);
        b = level>1 ? 1-level : 0;
        c = level>2 ? 2-level : 0;
        d = level>3 ? 3-level : 0;
        e = level>4 ? 4-level : 0;
        f = level>5 ? 5-level : 0;
        // And so on.. up to the batch_size-1
        for (y=[0:level])
        translate([y*(prism_side+prism_bias),(y+a+b+c+d+e+f)*(prism_side+prism_bias),0])
        cube([prism_side,prism_side,prism_side], center = true);
    }
    // Mirrors
    mirror_depth = 4;
    hypo = sqrt(pow(prism_side*3+3*prism_bias,2)*2);
    cat=sqrt(pow(hypo/2,2)*2);
    translate([prism_side/2+prism_bias,-prism_side/2,-9.5/2])
    rotate([0,0,45])
    cube([hypo,mirror_depth,9.5]);
    // Channels    
    for (i=[0:3])    
    translate([i*(prism_side+prism_bias),0,0])
    rotate([90,0,0])
    cylinder(d=6,h=140,$fn=resolution, center = true);        
    for (i=[0:2])
    translate([0,i*(prism_side+prism_bias),0])
    rotate([0,90,0])
    cylinder(d=6,h=130,$fn=resolution, center = true);
    // Left crope cube
    translate([-100/2-prism_side*2,100/2-prism_side,0])
    cube([100,120,50],center = true);
    // Screws
    for (x=[-1:4])    
    for (y=[0:3])
    translate([x*(prism_side+prism_bias)-(prism_side+prism_bias)/2,y*(prism_side+prism_bias)-(prism_side+prism_bias)/2,0])
    cylinder(d=4,h=130,$fn=resolution, center = true);
    // Inner_spacer
    color("blue")
    translate([0,15,0])
    cube([140,70,1], center = true);
}