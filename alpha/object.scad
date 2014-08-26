// (c) 2014, Stéphane Alnet

mm = 1;
cm = 10;
roundout = 0.05;

// Padding to account for the printer's inaccuracy.
radius_padding = 0.75*mm;

electronics_y = -18;
motor_x = -3.0;
motor_y = -1.5;
keep_centered = 0;
// Ideally the rod-length should be 51mm, but in that case the model needs pilars.
rod_length = 100*mm;

module objet_complet() {
  difference() {
    // The Wings3D model uses centimeters as units while OpenSCAD uses millimeters.
    // %
    scale(v=[cm,cm,cm]) import("object.stl");

    // The cylinder must be at least 24.5mm into the object for the motor to fit in.
    // Also set the diameter to slightly larger than needed to account for 
    // shape/resolution of printing.
    // #
    union() {

      // Hole for the 5mm rod that holds the pieces together.
      translate([5.5,rod_length/2-0,17])
      rotate([90,0,0])
      cylinder(h = rod_length, r = ((4+radius_padding)/2+0.05)*mm, $fn=100);

      union() {
        // Hole for the motor.
        translate([motor_x,motor_y,1.9*cm])
        rotate([90,0,0])
        // Cylinder is created at origin towards +Z.
        // Note: diameter (specs) is 7mm.
        // Note: actual length (24.55) is within tolerances, however must account for
        // bending radius of wires, which amounts to ~ total 27.7mm.
        cylinder(h = 24.5*mm*2.0, r = ((7+radius_padding)/2+0.05)*mm, $fn=100);

        // Transversal hole (diam=2.0mm) for the wires that connect to the motor.
        translate([motor_x,50,10+6/2-0.6])
        rotate([90,0,0])
        cylinder(h = 100*mm, r = (2+radius_padding)*mm, $fn=100);
      }

      // Hole for electronics.
      translate([keep_centered,electronics_y+70/2,10*mm])
      scale([17.1+radius_padding,70,6+radius_padding])
      cube (size = 1, center = true);

      // Ringy hole to put a security "pull" wire.
      translate([-3,41,20])
      rotate([30,-10,0])
      union () {
        // Torus
        rotate_extrude(convexity = 10, $fn = 100)
        translate([5, 0, 0])
        circle(r = (1+radius_padding), $fn = 100);

        rotate([0,0,180])
        translate([-4.0,4.5,0])

        scale([8,3.5,2.2])
        translate([0.5,0,0])
        intersection() {
          rotate([45,0,0])
          cube (size = 1, center = true);
          translate([0,-1,0])
          cube (size = 2, center = true);
        }
      }

    }
  };
};


// Object printout
// Stéphane@RobotSeed a recommandé de couper en deux et de prévoir des emboîtements.
cut_size = 90;
module cut(position,offset) {
  translate([keep_centered,position-cut_size/2-offset,cut_size/2-roundout])
  scale([cut_size,cut_size,cut_size])
  cube (size = 1, center = true);
};

module cut_a(offset) { cut(electronics_y,offset); };
module cut_b(offset) { cut(motor_y,offset); };

module ergot(position,size,offset) {
  translate([offset,position+size/2-roundout,17])
  scale([size,size,size])
  cube (size = 1, center = true);
}

//projection(cut = true) translate([0,0,-20*mm])

module piece_1() {
  intersection() {
    objet_complet();
    cut_a(roundout);
  }
}

module piece_2() {
  union() {
    intersection() {
      difference() {
        objet_complet();
        cut_a(-roundout);
      }
      cut_b(roundout);
    }
  }
}

module piece_3() {
  // intersection() {
  difference() {
    objet_complet();
    cut_b(-roundout);
  }
  // cut(34.95,0); }
}
// Arthur dit: remplacer les ergots par une tige filetée de 5mm sur toute la longueur.
