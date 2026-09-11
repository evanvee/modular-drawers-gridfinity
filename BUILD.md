# Drawer tower — build record

Fork of [smkent/modular-drawers-gridfinity](https://github.com/smkent/modular-drawers-gridfinity)
(CC BY-NC-SA 4.0), carrying the calibrated configuration for one specific build.
Upstream is unmodified; everything here is additive.

**This file exists so the build can be resumed from zero context.** Every number
below was measured or sliced, not estimated, unless it says otherwise.

---

## STATUS — 2026-09-11

**Plate 1 printed and VERIFIED. Dimensions confirmed on the machine; no tolerance
change needed.** Plates 2 and 3 cleared to print as-is.

Measured on the black housings (SUNLU HS PLA+, A1, 215/230, Flow Dynamics on):

| | Nominal | Measured | Δ |
|---|---|---|---|
| Outer height | 66.00 | 66.18 (mean of 5: 66.17/66.06/66.36/66.18/66.12) | +0.18 |
| Wall thickness | 5.00 | 5.01, 5.13 | +0.07 |
| **Inner opening (derived)** | **56.00** | **56.04** | **+0.04** |

Overall scale error is +0.27%, ordinary for PLA. Expected drawer gap 1.04 mm against
the designed 1.00 mm.

**MEASURE THE OPENING INDIRECTLY, NOT WITH INTERNAL JAWS.** A direct internal reading
gave 56.7 — 0.66 mm high — because the caliper's internal jaws spread the top and
bottom walls, which span 195 mm. Two independent signals caught it: the outer
dimension was only +0.18, and the dovetail interlock came out TIGHT, meaning internal
features print *small*, which is incompatible with walls thin enough to explain +0.7.
Derive the opening from `outer − 2 × wall` instead; wall thickness can be measured
end-on at the drawer opening where nothing can flex.

**Dovetail interlock: VERIFIED, assembles by hand, tight on first fit.** Leave it.
Snug is correct — it is what keeps a tall stack from racking, and PLA dovetails burnish
their layer-line high spots on the first few assemblies and then ease. Do NOT adjust
`dovetail_size` or `connector_support_tolerance` in `modules/constants.scad`: they are
not customizer parameters, the model flags them compatibility-altering, and changing
them means new housings will not mate with the ones already printed.

Open:

1. Print plate 2 (drawers), plate 3 (bins).
2. Decide whether magnets are needed at all — see **Magnets** below.

---

## The build

**4 units wide × 2 deep × 6u tall.** 8 Gridfinity cells per drawer, 2 drawers.

| File | Qty | Dimensions | Sliced mass |
|---|---|---|---|
| `starter/housing-4x2-h1.0.stl` | 2 | 195 × 69 × 98 mm | 333 g the pair |
| `starter/drawer-4x2-h1.0.stl` | 2 | 181 × 114 × 55 mm | 279.76 g the pair |
| `starter/bin-2x2x3.stl` | 1 | 84 × 84 × 25 mm | |
| `starter/bin-4x1x3.stl` | 1 | 168 × 42 × 25 mm | |
| `starter/bin-2x1x3.stl` | 2 | 84 × 42 × 25 mm | |
| `starter/bin-1x1x3.stl` | 4 | 42 × 42 × 25 mm | 225.37 g all 8 bins |

**~840 g, ~31 h, 3 plates, zero filament changes.** Bins fill both drawers exactly:
lower = 2×2 + 2×1 + 1×1 + 1×1, upper = 4×1 + 2×1 + 1×1 + 1×1, 8 cells each.

`starter/topplate-4x2.stl` (161 g) is **optional and deliberately not printed**. Each
housing is a closed tube with its own top wall, so the top drawer already has a
ceiling. The lid only adds a Gridfinity parking surface on top of the stack.

Regenerate everything with **`./render-starter.sh`**.

---

## Settled decisions — do not change without redoing the work behind them

**`Drawer_Tolerance = 0.5` is CALIBRATED, not a default.** Proven by printing
`calib-housing-xsection.stl` (a 6 mm slice of the housing) against
`calib-drawer-stub.stl` (a `Depth_Units=1` drawer carrying the real drawer's exact
cross-section), then checking the fit. It is an **absolute mm value** — it does not
scale with height or depth, so the calibration transfers across every module size.
Reprint that pair before changing it.

**One footprint forever: 4 wide × 2 deep.** Every bin fits every drawer only while
these never change. Mixing depths breaks alignment across the whole system. Depth 2
was chosen over 3 or 4 deliberately: a 202 mm-deep drawer puts the back row out of
easy reach, and capacity is better grown sideways (see *Interlock*). It costs ~26%
more filament per cell than depth 4 — that is the price of the ergonomics.

**`Height_Units` is in 6u Gridfinity increments, not 1u.** `1.0` = 6u, `1.5` = 9u,
`2.0` = 12u. `0.5` (3u) exists but is too short to hold any Gridfinity bin — 23 mm of
housing interior against a 24.8 mm bin.

**Each unit costs 48 mm of width, 44 mm of depth, 66 mm of height** — not 42. The
42 mm Gridfinity pitch is the *cell*; the housing adds structure around it.

**`style_tab = 1` (Auto) on every bin.** This gives a **one-unit (36 mm) tab
regardless of bin width**, so a single label-insert size fits every bin ever printed.
`style_tab = 0` (Full) would give a 4×1 bin a 167 mm tab needing its own label size.
This is baked into the plastic — changing it means reprinting.

**Interlock works in both directions.** Housings carry dovetails on top/bottom *and*
on the left/right edges (tabs protrude 3 mm on the right, slots are cut into the
left). The tower grows up **or** sideways with no adapter part.

---

## Material and printer settings

**Printer:** Bambu Lab A1, 0.4 mm nozzle, Textured PEI plate.
**Filament:** SUNLU High Speed PLA+, 1.75 mm — black (housings) and white
(drawers + bins). Same material both colours, so the housing↔drawer fit is
like-for-like.

Bambu Studio preset: cloned from **Generic PLA High Speed**, saved as
`SUNLU PLA Sunlu HS PLA+ @Bambu Lab A1 0.4 nozzle`.

| | Initial layer | Other layers |
|---|---|---|
| Nozzle | **215 °C** | **230 °C** |
| Bed (Textured PEI) | **60 °C** | **55 °C** |

**Why those numbers.** The spool label gives speed-dependent temperatures:
200–215 °C at 50–150 mm/s, 215–230 °C at 150–300 mm/s, 230–260 °C at 300–600 mm/s.
This profile runs **outer wall 60, inner wall 300, sparse infill 270, internal solid
250 mm/s** — so the bulk of the material lands at the top of the 215–230 band, hence
230. The initial layer runs at 50 mm/s, which is the 200–215 band, hence 215 — and a
cooler first layer also reduces elephant's foot, which eats directly into the 0.5 mm
clearance.

**Run Flow Dynamics calibration** for this filament. It is the step that protects the
tolerance across a filament change.

**Orientation:** rotate housings so the **195 mm dimension runs along Y**. The A1 is a
bed slinger — the bed accelerates in Y, and a 98 mm-tall part on a 69 mm base takes
that for 15 hours. With 195 mm of base in Y a brim is unnecessary.

**External spool:** the four toolhead inlets are identical; use any. Select **Ext** in
the Send-print-job dialog so it feeds from the spool holder, not the AMS.

---

## Magnets — 6 × 2 mm, and not yet bought

Pockets are **6.5 mm ⌀ × 2.4 mm**, sized for **6 × 2 mm** neodymium discs.
**Four per Gridfinity cell.** Verified present in bins, drawer baseplates and the lid
by differential facet count (generating each part with and without the option).
Housings have none.

| | Magnets |
|---|---|
| 2 drawer baseplates | 64 |
| 8 bins | 64 |
| **This build** | **128** |
| Lid, if ever printed | +32 |

**They work as pairs — bin magnet to baseplate magnet.** A magnet in the bin sitting
on bare plastic does nothing, so it is both or neither. That is why the count doubles.

**POLARITY IS UNRECOVERABLE ONCE GLUED.** Every bin magnet must face one way and every
baseplate magnet the other, or roughly half the bins will actively push themselves out
of the drawer. Keep the discs in their shipped stack, always take from the same end,
never flip one to make it sit nicer. Do all bins, then reverse direction for the
baseplates.

Pockets open downward and stay accessible after printing — **magnets can be added at
any time with no reprinting**, so this does not block anything.

**Open question, still untested:** whether magnets are needed at all. The baseplate
lip already stops bins sliding sideways; magnets only resist lifting. Load the printed
bins into a drawer, tip and shake it. If nothing moves, skip 128 magnets entirely.

Source used for pricing: 6×2 mm neodymium, ~$0.04/each in a 320 pack. A "6 sizes"
assortment will **not** work — those kits jump 3 mm → 8 mm and skip 6 mm entirely.

---

## Labels

The tab is a **sloped shelf with a small raised outer edge and no channel, undercut or
clip geometry** — confirmed by sectioning a bin. Nothing is built in for a label to
snap into, and **no printed label will stay on by itself**.

Three options: adhesive label-maker tape (recommended — instant, and peels when the
bin's contents change); a printed insert that clips *over* the tab from the front;
or nothing. Magnetic labels are not possible without modifying the model — the tab
has no magnet pocket.

Labels and magnets are **entirely separate systems**. Magnets hold the bin to the
drawer; they have nothing to do with labels.

---

## Gotchas found the hard way

**`Top_Plate_Type = 0` does not give a flat lid.** The side and back walls are
separate flags. Leaving them on costs 42 g for nothing —
`Enable_Top_Plate_Left_Side` / `_Right_Side` / `_Back` must all be `false`.

**Pass `-D` flags inline.** A zsh variable holding them does not word-split, and
OpenSCAD fails with a parser error at a line *past the end of the file* — a confusing
symptom with an unrelated-looking cause.

**Mass estimation from solid mesh volume** is accurate to ~2% for housings and drawers
(they print nearly solid — thick walls dominate) and runs **~29% high for bins**, which
are mostly enclosed air. Do not use one ratio for both. Measured print rate varies by
part: 22.5 g/h for housings, 29.9 for drawers, 33.5 for bins.

**Dropping sparse infill barely helps.** These parts are almost all perimeter — 10%
infill saved 8 minutes on a 5h37m plate. The real cost is wall count and part height.

---

## Files

| | |
|---|---|
| `render-starter.sh` | regenerates the whole depth-2 starter set — **the reproducible artifact** |
| `render-tower.sh` | the larger depth-4 tower set (3 heights + shelf), superseded but kept |
| `starter/` | generated STLs (gitignored) |
| `scene/*.scad` | assembly scenes for rendering — tower, side-by-side, loaded drawer, bin anatomy |
| `renders/` | rendered PNGs (gitignored, regenerable from `scene/`) |

Interactive 3D viewer of the assembled build:
<https://claude.ai/code/artifact/5a7e569b-966e-4462-8810-a3c97079b129>
