include <object.scad>;

// Put piece 2 onto the ground.
translate([0,0,-electronics_y-roundout])
rotate([90,0,0])
piece_2();
