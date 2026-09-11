// Drawer with a mixed bin layout. Cell pitch 42mm.
// X cell centres: -63 -21 21 63     Y cell centres: -157 -115 -73 -31
ZB = 4.90;   // top of the drawer's baseplate

color("#8fae8b") import("../drawer-4x4-h1.5.stl");

module put(f, x, y) { translate([x, y, ZB]) color("#cf7b5c") import(f); }

put("bin-2x2x9.stl", -42, -136);   // cols 0-1, rows 0-1
put("bin-2x1x9.stl",  42, -157);   // cols 2-3, row 0
put("bin-1x1x9.stl",  21, -115);
put("bin-1x1x9.stl",  63, -115);
put("bin-4x1x9.stl",   0,  -73);   // full width
put("bin-3x1x9.stl", -21,  -31);
put("bin-1x1x9.stl",  63,  -31);
