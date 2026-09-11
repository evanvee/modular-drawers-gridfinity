#!/usr/bin/env bash
# Regenerate the whole drawer tower. Verified 2026-09-10 on a Bambu 256^3.
#
# Drawer_Tolerance = 0.5 is CALIBRATED, not a default: proven with a printed
# housing cross-section + a Depth_Units=1 stub drawer sharing the real drawer's
# 181 x 88 cross-section. Do not change it without re-running that gauge.
#
# One footprint forever (4x4) and one tolerance is what keeps every bin
# interchangeable with every drawer. Vary Height_Units only.
set -euo pipefail
cd "$(dirname "$0")"

W=4; D=4; TOL=0.5; MAG=2      # MAG=2 -> Gridfinity baseplate WITH magnet pockets

# NOTE: pass -D flags inline. A shell variable holding them does not word-split
# under zsh and OpenSCAD fails with a parser error past the end of the file.
for H in 1.0 1.5 2.0; do
  openscad -o "housing-${W}x${D}-h${H}.stl" \
    -D Width_Units=$W -D Depth_Units=$D -D Height_Units=$H \
    -D Drawer_Tolerance=$TOL -D Drawer_Bottom_Type=$MAG \
    -D Create_Housing=true -D Create_Drawer=false \
    -D Create_Top_or_Bottom_Plate=false models.scad
  openscad -o "drawer-${W}x${D}-h${H}.stl" \
    -D Width_Units=$W -D Depth_Units=$D -D Height_Units=$H \
    -D Drawer_Tolerance=$TOL -D Drawer_Bottom_Type=$MAG \
    -D Create_Housing=false -D Create_Drawer=true \
    -D Create_Top_or_Bottom_Plate=false models.scad
done

# Top of the stack: a shelf with its own Gridfinity base (Top_Plate_Type=1).
# Use Top_Plate_Type=0 for a flat lid instead.
openscad -o "topplate-shelf-${W}x${D}.stl" \
  -D Width_Units=$W -D Depth_Units=$D -D Height_Units=1.5 \
  -D Create_Housing=false -D Create_Drawer=false \
  -D Create_Top_or_Bottom_Plate=true -D Plate_Model_Type=1 \
  -D Top_Plate_Type=1 -D Top_Plate_Base_Type=$MAG models.scad

# Calibration gauge — reprint this pair before changing TOL.
openscad -o calib-housing-xsection.stl \
  -D Width_Units=$W -D Depth_Units=$D -D Height_Units=1.5 \
  -D Drawer_Tolerance=$TOL -D Housing_Cross_Section=true \
  -D Create_Housing=true -D Create_Drawer=false \
  -D Create_Top_or_Bottom_Plate=false models.scad
openscad -o calib-drawer-stub.stl \
  -D Width_Units=$W -D Depth_Units=1 -D Height_Units=1.5 \
  -D Drawer_Tolerance=$TOL -D Drawer_Bottom_Type=$MAG \
  -D Create_Housing=false -D Create_Drawer=true \
  -D Create_Top_or_Bottom_Plate=false models.scad

# Bins, from the vendored generator. style_hole=1 -> magnet holes to match.
( cd third_party/gridfinity-rebuilt-openscad
  openscad -o ../../bin-2x1x3.stl -D gridx=2 -D gridy=1 -D gridz=3 \
    -D divx=1 -D divy=1 -D style_hole=1 -D style_tab=5 -D scoop=0 \
    gridfinity-rebuilt-bins.scad )

echo "done — $(ls -1 *.stl | wc -l | tr -d ' ') STLs"
