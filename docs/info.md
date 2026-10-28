# Ultimate Chess Clock

The active design is a two-player chess clock with configurable minutes,
seconds, increment, player-turn controls, pause behavior, BCD time displays,
and timeout status.

## Status

- RTL: draft in `src/ultimate_chess_clock.sv`
- Tiny Tapeout wrapper scaffold: `src/tt_um_guitarfan_ultimate_chess_clock.v`
- Testbench: draft in `test/ultimate_chess_clock_tb.sv`
- Physical config: `src/config.json`
- Target PDK: GF180MCU
- Target tile: `160 x 100 um`
- FPGA status: not yet tested
- Physical status: the earlier majority-vote design has a reference GF180 run;
  the chess-clock design still needs its own successful hardening run

## Known issues

The current testbench and RTL need an explicit pause/resume contract. The
SystemVerilog testbench also needs waveform dump commands and a simulator
compatible with its task argument style. The wrapper is currently a scaffold;
its pin allocation and internal instantiation must be completed before
submission.
