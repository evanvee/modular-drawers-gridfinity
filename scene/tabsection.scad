// Cut a 1x1 bin down the middle to expose the label tab's cross-section.
difference(){
  color("#8fae8b") import("../starter/bin-1x1x3.stl");
  translate([0,-60,-10]) cube([60,120,60]);   // remove the +X half
}
