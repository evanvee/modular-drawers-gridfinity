// Assembled tower. Housing STL is in PRINT orientation (Z=depth, Y=height),
// so rotate([-90,0,0]) stands it up: X=width, Y=depth, Z=height.
LVL = 102;      // housing height incl. dovetail, h1.5
ZB  = 4.90;     // top of drawer baseplate
DY  = -140;     // how far the open drawer is pulled forward

module housing(z) { translate([0,0,z+LVL]) rotate([-90,0,0])
                    color("#b9c4c9") import("../housing-4x4-h1.5.stl"); }

module put(f,x,y){ translate([x,y,ZB]) color("#cf7b5c") import(f); }

module bins() {
  put("bin-2x2x9.stl",-42,-136); put("bin-2x1x9.stl", 42,-157);
  put("bin-1x1x9.stl", 21,-115); put("bin-1x1x9.stl", 63,-115);
  put("bin-4x1x9.stl",  0, -73); put("bin-3x1x9.stl",-21, -31);
  put("bin-1x1x9.stl", 63, -31);
}

module loaded_drawer(z, dy) {
  translate([0, dy, z]) {
    color("#8fae8b") import("../drawer-4x4-h1.5.stl");
    bins();
  }
}

housing(0); housing(LVL); housing(2*LVL);
loaded_drawer(2*LVL + 8, 190);
loaded_drawer(LVL + 8, 190 + DY);
loaded_drawer(8, 190);
