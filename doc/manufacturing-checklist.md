# Manufacturing Checklist

Follow these steps before shipping a board off for manufacturing:

## Schematic

1. Open Schematic.
1. Run "Annotate Schematic".  No changes are expected.
1. Run "Electrical Rule Checker".  Verify no errors.
   1. Caveat: Ignore FPGA tristate-to-other-pins errors.
1. Check that all footprints are assigned.
1. In "Page Settings":
   1. Set "Issue Date" to today.  Check "Export to other sheets."
   1. Increment "Revision".  Check "Export to other sheets."
1. Plot the schematic.
   1. Format: PDF
   1. Output director: `~/spla`.
   1. Click "Plot All Pages"
   1. Verify output PDF in `~/spla/spla-board.pdf`.
1. Generate Bill of Materials.
   1. Use `bom2csv` plugin, but only for the `.xml` output file.
1. Save and close the schematic.
1. Commit all of the above.
   1. Commit description: "schematic: Export revision {REV}.".
   1. Tag the commit as `schematic-rXXX`.

## PCB

1. Open PCB.
1. Run "Update PCB from schematic".  Expect no changes.
1. Run "Design Rule Checker".
   1. Check "Refill all zones...".
   1. Click "Run DRC". Verify no errors.
1. In "Page Settings":
   1. Set "Issue Date" to today.
   1. Increment "Revision".
1. Update traceability markings to match.
1. Save.
1. Screenshot PCB, and save in `images/`.
   1. Update link in README to match.
1. Commit all of the above.
   1. Commit description: "pcb: Export revision {REV}.".
   1. Tag the commit as `pcb-rXXX`.

## Gerber files

1. Plot the PCB [according to JLCPCB's article](https://support.jlcpcb.com/article/44-how-to-export-kicad-pcb-to-gerber-files):
   1. Plot format: `Gerber`
   1. Output directory: `./gerber` (inside project directory).
   1. Layers: `F.Cu`, `In1.Cu`, `In2.Cu`, `B.Cu`, `F.Paste`, `B.Paste`, `F.SilkS`, `B.SilkS`, `F.Mask`, `B.Mask`, `Edge.Cuts`.
   1. Options
      1. Check "Plot footprint values" _(necessary?)_
      1. Check "Plot footprint references" _(necessary?)_
      1. Uncheck "Exclude PCB edge layer...".
      1. Other options are default.
   1. Click "Plot".
   1. Click "Generate Drill Files"
      1. Options:
         1. Drill File Format: "Excellon"
         1. Check "PTH and NPTH in single file".
         1. Map File Format: PostScript
         1. Drill Origin: Absolute
         1. Drill Units: Inches
         1. Zeros Format: Decimal format.
      1. Click "Generate Drill File".
1. Verify generated files in Gerber Viewer.
   1. In particular, check traceability markings.
1. (Optional) Print Front / Back layouts on paper.
   1. "Print..."
      1. Included Layers: "F_Cu.gbr"
      1. Uncheck "Print Mirrored"
      1. Print to file "output-front.pdf"
   1. "Print..."
      1. Included Layers: "B_Cu.gbr"
      1. Uncheck "Print Mirrored"
      1. Print to file "output-back.pdf"
   1. Print both files on paper and verify footprints.
1. Commit all of the above.
   1. Commit description: "manufacturing: Export Gerber files revision {REV}.".
   1. Tag the commit as `manufacturing-rXXX`.
1. Zip the generated files. _(Don't bother committing the zip file.)_
   1. cd to `spla-board/gerber`.
   1. Run `zip /mnt/shared/spla-board-rXXX-gerber.zip *.gbr *.drl`

## Ordering via JLCPCB

1. JLCPCB options:
   1. Layers: 4 (required)
   1. Dimensions: (from gerber files)
   1. PCB Qty: (arbitrary)
   1. Different Design: 1
   1. Delivery Format: Single PCB
   1. PCB Thickness: 1.6mm
   1. Impedence: No (Not sure this matters)
   1. PCB Color: Green
   1. Surface Finish: ENIG-RoHS
   1. Copper Weight: 1oz
   1. Gold Finders: No
   1. Material Type: FR-4 TG155 (will be required later anyways)
   1. Castellated Holes: No
   1. Remove Order Number: Specify Location
   1. Advanced Options
      1. Min Hole Size / Diameter: 0.2mm/0.4mm
      1. Paper between PCBs: Yes
      1. Confirm Production File: No
   1. Stencil
      1. Framework: No
      1. Dimensions: 380*280
      1. Customized Size: 200mm*150mm (this might be backwards)
      1. Stencil Side: Top+Bottom on separate stencil
      1. Stencil Qty: 2
      1. Electropolishing: Yes (useful for small pitch / BGA)
      1. Fiducials: No Fiducials
