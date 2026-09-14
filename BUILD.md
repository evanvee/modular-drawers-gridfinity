# Drawer tower — build record

Fork of [smkent/modular-drawers-gridfinity](https://github.com/smkent/modular-drawers-gridfinity)
(CC BY-NC-SA 4.0), carrying the calibrated configuration for one specific build.
Upstream is unmodified; everything here is additive.

**This file exists so the build can be resumed from zero context.** Every number
below was measured or sliced, not estimated, unless it says otherwise.

---

## STATUS — 2026-09-12 · BUILD COMPLETE

**All three plates printed. Everything fits.** Two housings, two drawers, eight bins —
a working two-drawer module, ~840 g, ~31 h across three single-colour plates.

The configuration in this repo is now **validated end to end**: calibration gauge →
housings → drawers → bins → assembled module. Reprinting `./render-starter.sh` output
at these settings reproduces a known-good result. Nothing here is provisional.

Verified along the way, on the machine:

| | Nominal | Measured | Δ |
|---|---|---|---|
| Housing outer height | 66.00 | 66.18 (mean of 5) | +0.18 |
| Housing wall | 5.00 | 5.01, 5.13 | +0.07 |
| **Housing inner opening (derived)** | **56.00** | **56.04** | **+0.04** |

Overall scale error +0.27%, ordinary for PLA. `Drawer_Tolerance = 0.5` confirmed
correct against real parts, not just against the gauge.

**MEASURE AN OPENING INDIRECTLY, NOT WITH INTERNAL JAWS.** A direct internal reading
gave 56.7 — 0.66 mm high — because the jaws spread walls spanning 195 mm, and it very
nearly caused a needless tolerance correction. Two signals contradicted it: the outer
dimension was only +0.18, and the dovetail interlock came out TIGHT, meaning internal
features print *small*, which is incompatible with walls thin enough to explain +0.7.
Derive it from `outer − 2 × wall`, measuring wall end-on at the drawer opening where
nothing can flex.

**Dovetail interlock: assembles by hand, tight on first fit. Leave it.** Snug is what
keeps a tall stack from racking, and PLA dovetails burnish their layer-line high spots
over the first few assemblies. Do NOT adjust `dovetail_size` or
`connector_support_tolerance` in `modules/constants.scad`: they are not customizer
parameters, the model flags them compatibility-altering, and changing them means new
housings will not mate with the ones already printed.

**Magnets fitted and working.** 6 x 2 mm, seated per the procedure in **Magnets**
below. This closes the last V1 question.

**V1 IS FROZEN AND SHIPPED.** Everything above is settled and validated against real
parts. Improvements go in **Enhancement backlog** at the end of this file — do not
quietly change V1 settings; a change that breaks compatibility with printed parts is
a V2 decision, not a tweak.

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

---

# Enhancement backlog — V2 and beyond

V1 works. Nothing here is required. Each item records what is actually blocking it, so
a later session does not re-derive the analysis. Ordered by value-for-effort, honestly
assessed rather than optimistically.

## Ready — no unknowns, just work

**Divided bins.** *Every V1 bin is a single compartment, and that was never a decision
— it is just `divx = 1, divy = 1`, the default we never revisited.* The generator takes
`divx`/`divy` and cuts internal dividers. For screws, pins and small hardware this is
probably the single biggest usability win available, and it costs nothing but a
reprint of the bins you want divided. Bins are the cheapest part in the system and
carry no compatibility risk — the external profile is unchanged. **Start here.**

**Taller bins.** V1 printed only 3u bins. `gridz = 6` fits the same 6u drawer with
room. Useful wherever a 3u tray is too shallow.

**Other bin footprints.** 3x1 and 2x2 at 6u are already generated by
`render-starter.sh`'s sibling calls. Any combination summing to 8 cells works.

**More modules.** Same footprint and tolerance, vary only `Height_Units`
(`1.0`=6u, `1.5`=9u, `2.0`=12u). Stacks up or sideways on the same dovetails. No
calibration needed — that work is done.

**The top lid.** `starter/topplate-4x2.stl`, 161 g, never printed. Optional: it adds a
Gridfinity parking surface on top of the stack. Remember `Top_Plate_Type = 0` alone does
NOT remove the side walls — `Enable_Top_Plate_Left_Side` / `_Right_Side` / `_Back` must
all be false, or you pay 42 g for nothing.

**A bottom plate.** `Plate_Model_Type = 0` exists and was never explored. Would give the
tower a finished foot.

## Needs a decision before it is worth building

**Drawer self-closing magnets.** Analysed 2026-09-14; **the geometry fights it.**
Three blockers, all measured:

- **Zero clearance behind a closed drawer** — drawer body 95.0 mm, housing interior
  95.0 mm. A magnet pair is 4 mm of stack, so the drawer would stand 4 mm proud.
- **Both back walls are honeycomb** (`Housing_Back_Wall_Fill = 3`,
  `Drawer_Back_Wall_Fill = 3`), so you cannot drill a reliable pocket into the printed
  parts — you hit voids.
- **At the front the faces are coplanar, not opposed.** The drawer face sits flush
  *inside* the opening with the housing rim around it. No facing surfaces to attract.

So there is no clean retrofit to V1 parts. Two real options, both V2:

- **(A)** Model change: recessed pockets in the drawer back face and housing back wall,
  with solid material around them. ~30 lines of OpenSCAD. New drawers then self-close
  only in new housings — a mixed tower.
- **(B)** Asymmetric: recess a magnet in a new drawer's back face, glue a 0.5 mm steel
  washer to the existing housing's back wall. Reprints drawers only and keeps the
  housings, at the cost of gluing a washer 95 mm deep through the front opening.

**BLOCKED ON: is this a real problem?** In a vertical tower gravity does not pull a
drawer open, and the catch already prevents fall-out. Establish that drawers actually
drift — and in which direction — before building either option.

**Printed label inserts.** The tab is already future-proofed: `style_tab = 1` gives a
uniform **one-unit, 36 mm tab on every bin regardless of width**, so one insert
geometry fits the whole system forever. But the tab is a **sloped shelf with no
channel, undercut or clip geometry** (confirmed by sectioning a bin), so an insert must
clip *over* it from the front. That fit is its own calibration loop, exactly like
`Drawer_Tolerance` was — expect to iterate on 3-4 test prints before committing to a
plate of sixty. About 60-100 labels fit on one 256 mm plate, so the "many small prints"
worry is unfounded; batching solves it.

**BLOCKED ON: layout stability.** A printed label is effectively permanent and the whole
point of Gridfinity is rearranging. Use label-maker tape until a drawer has gone weeks
without you moving anything, then print inserts for those bins only.

**Halving the magnet count.** Nothing requires all four pockets per cell — two on a
diagonal should still resist lifting and would cut a full build from 128 to 64.
Untested. Worth trying on the next module before committing to four everywhere.

## Probably not worth it

**Lighter print settings.** V1 ran 6 wall loops and 25% infill — heavier than needed.
Trimming would save maybe 30 g per module. But these parts are almost entirely
perimeter (dropping infill to 10% saved 8 minutes on a 5h37m plate), so the saving is
small and the risk is weakening the dovetails, which flex every time a module is
assembled. Leave it.

**Flow ratio calibration.** V1 ran Flow *Dynamics* only. Flow *ratio* is what governs
dimensional accuracy, and we never calibrated it — but the parts came out at +0.27%,
which is ordinary PLA shrinkage and well inside tolerance. Nothing to fix.

**Deeper modules.** Depth 3 or 4 would be more filament-efficient per cell (~26% better
at depth 4). But **depth is the one dimension that must never vary** — mixing depths
breaks alignment across the whole system. If you ever want deeper drawers, build a
SEPARATE tower, do not extend this one.
