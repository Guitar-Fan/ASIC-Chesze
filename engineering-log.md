# Engineering Log

## 2026-10-09

- Installed rootless Nix with `nix-portable` in Hack Club Spaces.
- Restored LibreLane 3.0.16, Yosys 0.62, and the Ciel toolchain.
- Installed and enabled GF180MCU release 2026.10.01.
- Ran the majority-vote reference design through LibreLane with a fixed
  `160 x 100 um` die. Magic DRC, LVS, antenna, and routing DRC passed.
- KLayout DRC was skipped because its GF180 runset was not configured.

## 2026-10-19

- Added the user-authored ultimate chess-clock RTL and SystemVerilog testbench.
- Verilator compiled the pair, but verification stopped at the pause/resume
  assertion because the RTL and testbench define MODE behavior differently.
- Icarus Verilog rejected the testbench's `ref logic` task argument.
- No chess-clock VCD is considered valid until the testbench passes and includes
  waveform dump commands.

## 2026-10-22

- Reorganized the active draft into root `src/` and `test/` directories.
- Added draft metadata and submission documentation.
- The Tiny Tapeout wrapper, current template workflows, FPGA files, and external
  write-up remain to be completed.
