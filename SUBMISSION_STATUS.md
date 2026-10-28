# Submission Status

As of 2026-10-22, this repository is a structured draft, not a final Hack Club
submission.

## Complete

- Root `src/` and `test/` directories exist.
- Active chess-clock RTL and testbench are in those directories.
- GF180MCU LibreLane config exists at `src/config.json`.
- GF180MCU PDK and LibreLane toolchain are available in Spaces.
- Root documentation, engineering log, BOM, and build placeholder exist.
- Historical majority-vote physical-flow artifacts are preserved.

## Required before submission

- Start from the current official Tiny Tapeout GF180MCU template.
- Complete the `tt_um_guitarfan_ultimate_chess_clock` wrapper and pin interface
	scaffold in `src/tt_um_guitarfan_ultimate_chess_clock.v`.
- Update `info.yaml` to the official template schema and wrapper name.
- Resolve the chess-clock pause/resume behavior mismatch.
- Add VCD/FST dump commands and obtain a passing simulation waveform.
- Add the official template workflows and make them pass from a clean checkout.
- Add FPGA top-level files, pin constraints, bitstream, and test evidence.
- Run physical implementation on the wrapped chess-clock design.
- Resolve or document the GF180 KLayout DRC runset requirement.
- Publish the required external write-up.
- Choose and add the project license.

Do not submit the current draft as final: its module is not yet a Tiny Tapeout
`tt_um_*` wrapper and its chess-clock verification is not passing.
