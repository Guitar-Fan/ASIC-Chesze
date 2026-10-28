# Simulation

The chess-clock testbench is `ultimate_chess_clock_tb.sv` and the RTL is in
`../src/ultimate_chess_clock.sv`.

Run from this directory inside the LibreLane Nix shell:

```bash
make lint
make sim
```

The testbench must define its VCD/FST dump commands and complete without
assertion failures before the waveform is evidence for submission. GTKWave is a
native GUI application and may need to be run on a machine with a display.
