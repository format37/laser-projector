batch_size = 3;
prism_side = 15;
prism_bias = 1;

for (level=[0:batch_size])
{
    for (y=[0:level*2])
    {
        start_bias = pow(level,2)-level;
        translate([y*(prism_side+prism_bias),(start_bias+level+y)*(prism_side+prism_bias),0])
        cube([prism_side,prism_side,prism_side], center = true);
    }
}