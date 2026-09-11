// Mixed-height tower, weighted SHALLOW. Stack pitch = housing_outer_height.
P10 = 66; P20 = 132;      // pitch for h1.0 and h2.0
ZB  = 4.90;

module h_low(z)  { translate([0,0,z+69])  rotate([-90,0,0]) color("#b9c4c9") import("../housing-4x4-h1.0.stl"); }
module h_tall(z) { translate([0,0,z+135]) rotate([-90,0,0]) color("#b9c4c9") import("../housing-4x4-h2.0.stl"); }
module put(f,x,y){ translate([x,y,ZB]) color("#cf7b5c") import(f); }

module small_bins() {            // 3u bins in a 6u drawer — shallow tray
  put("bin-2x2x3.stl",-42,-136); put("bin-2x1x3.stl", 42,-157);
  put("bin-1x1x3.stl", 21,-115); put("bin-1x1x3.stl", 63,-115);
  put("bin-4x1x3.stl",  0, -73); put("bin-2x1x3.stl",-42, -31);
  put("bin-1x1x3.stl", 21, -31); put("bin-1x1x3.stl", 63, -31);
}
module low_drawer(z, dy) { translate([0,dy,z]) { color("#8fae8b") import("../drawer-4x4-h1.0.stl"); small_bins(); } }
module tall_drawer(z, dy){ translate([0,dy,z]) color("#8fae8b") import("../drawer-4x4-h2.0.stl"); }

// four shallow levels, one tall at the bottom
h_tall(0);          tall_drawer(6, 190);
h_low(P20);         low_drawer(P20+6, 190);
h_low(P20+P10);     low_drawer(P20+P10+6, 190-150);   // open
h_low(P20+2*P10);   low_drawer(P20+2*P10+6, 190);
h_low(P20+3*P10);   low_drawer(P20+3*P10+6, 190);
