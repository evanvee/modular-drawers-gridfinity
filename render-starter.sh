#!/usr/bin/env bash
# Depth-2 starter tower — regenerates every STL in starter/ from scratch.
#
# SETTLED PARAMETERS, none of them defaults:
#   Drawer_Tolerance = 0.5   CALIBRATED. Proven with a printed housing cross-section
#                            + a Depth_Units=1 stub drawer. Absolute mm, so it does not
#                            scale with height or depth. Do not change without re-running
#                            the gauge at the bottom of this script.
#   Width_Units  = 4         ONE FOOTPRINT FOREVER. Every bin fits every drawer only
#   Depth_Units  = 2         while these two never change. Mixing depths breaks alignment.
#   Height_Units = 1.0       = 6u. The model steps in 6u increments; 0.5 (3u) is too
#                            short to hold any Gridfinity bin.
#   Drawer_Bottom_Type = 2   Gridfinity baseplate WITH 6.5mm magnet pockets.
#                            Magnets are 6 x 2 mm. Pockets open downward and stay
#                            accessible after printing, so magnets can be added later.
#
# Bins use style_tab=1 (Auto) which gives a ONE-UNIT tab on every bin regardless of
# width, so a single label-insert size fits the whole system. That is baked into the
# plastic; changing it later means reprinting.
#
# NOTE: pass -D flags inline. A shell variable holding them does not word-split under
# zsh and OpenSCAD fails with a parser error past the end of the file.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p starter
rm -f starter/*.stl
G=third_party/gridfinity-rebuilt-openscad

# --- structure -------------------------------------------------------------
openscad -o starter/housing-4x2-h1.0.stl \
  -D Width_Units=4 -D Depth_Units=2 -D Height_Units=1.0 -D Drawer_Tolerance=0.5 \
  -D Drawer_Bottom_Type=2 -D Create_Housing=true -D Create_Drawer=false \
  -D Create_Top_or_Bottom_Plate=false models.scad

openscad -o starter/drawer-4x2-h1.0.stl \
  -D Width_Units=4 -D Depth_Units=2 -D Height_Units=1.0 -D Drawer_Tolerance=0.5 \
  -D Drawer_Bottom_Type=2 -D Create_Housing=false -D Create_Drawer=true \
  -D Create_Top_or_Bottom_Plate=false models.scad

# Flat lid. Top_Plate_Type=0 alone does NOT remove the side walls — those are
# separate flags, and leaving them on costs 42 g for nothing.
openscad -o starter/topplate-4x2.stl \
  -D Width_Units=4 -D Depth_Units=2 -D Height_Units=1.0 \
  -D Create_Housing=false -D Create_Drawer=false -D Create_Top_or_Bottom_Plate=true \
  -D Plate_Model_Type=1 -D Top_Plate_Type=0 -D Top_Plate_Base_Type=2 \
  -D Enable_Top_Plate_Left_Side=false -D Enable_Top_Plate_Right_Side=false \
  -D Enable_Top_Plate_Back=false models.scad

# --- bins: exactly fill two drawers, 8 cells each ---------------------------
# lower: 2x2 + 2x1 + 1x1 + 1x1     upper: 4x1 + 2x1 + 1x1 + 1x1
bin() {  # bin <gx> <gy> <gz>
  ( cd "$G" && openscad -o "../../starter/bin-$1x$2x$3.stl" \
      -D gridx=$1 -D gridy=$2 -D gridz=$3 -D divx=1 -D divy=1 \
      -D style_hole=1 -D style_tab=1 -D scoop=1 gridfinity-rebuilt-bins.scad )
}
bin 2 2 3; bin 4 1 3; bin 2 1 3; bin 1 1 3

# --- calibration gauge (reprint only if changing Drawer_Tolerance) ----------
openscad -o starter/calib-housing-xsection.stl \
  -D Width_Units=4 -D Depth_Units=2 -D Height_Units=1.0 -D Drawer_Tolerance=0.5 \
  -D Housing_Cross_Section=true -D Create_Housing=true -D Create_Drawer=false \
  -D Create_Top_or_Bottom_Plate=false models.scad
openscad -o starter/calib-drawer-stub.stl \
  -D Width_Units=4 -D Depth_Units=1 -D Height_Units=1.0 -D Drawer_Tolerance=0.5 \
  -D Drawer_Bottom_Type=2 -D Create_Housing=false -D Create_Drawer=true \
  -D Create_Top_or_Bottom_Plate=false models.scad

echo "starter/: $(ls -1 starter/*.stl | wc -l | tr -d ' ') STLs"
