// Two housings side by side + one on top, to test lateral vs vertical joins.
W = 195;   // housing outer width incl. connector
LVL = 66;  // vertical pitch for h1.0
module H(x,z){ translate([x,0,z+69]) rotate([-90,0,0]) color("#b9c4c9") import("../housing-4x4-h1.0.stl"); }
H(0,0); H(W,0); H(0,LVL); H(W,LVL);
