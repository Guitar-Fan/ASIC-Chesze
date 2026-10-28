# ASIC-Chesze

Hack Club GF180MCU ASIC project targeting a `160 x 100 um` tile.

The active draft design is an RTL chess clock. It is currently organized into
the Tiny Tapeout-style source and test directories, but it is not submission
ready until the required `tt_um_` wrapper, template metadata, workflows, FPGA
files, and verification evidence are completed.

## Layout

```text
.
├── src/                    # Active synthesizable RTL and physical config
├── test/                   # Active SystemVerilog testbench
├── docs/                   # Project and evidence documentation
├── build/                  # Reserved for reproducible build outputs
├── majority_vote/          # Historical verified majority-vote run
├── librelane/              # LibreLane 3.0.16 toolchain source
├── info.yaml               # Draft project metadata
├── plan.md                 # Two-design submission plan
├── requirements.md         # Submission requirements and migration checklist
├── engineering-log.md      # Dated engineering notes
└── terminal.md             # Spaces/Nix toolchain commands
```

## Current design

`src/ultimate_chess_clock.sv` implements the current chess-clock draft and
`test/ultimate_chess_clock_tb.sv` exercises it. The testbench currently needs a
defined pause/resume behavior and VCD tracing before it can be considered a
passing submission test.

The physical config is `src/config.json`; it targets GF180MCU, the
`ultimate_chess_clock` top module, a 10 ns clock, and a `160 x 100 um` die.

## Toolchain

Start the verified Spaces toolchain with:

```bash
cd /config/workspace/ASIC-Chesze/librelane
nix develop
```

See [terminal.md](terminal.md) for Nix, Ciel, simulation, and LibreLane
commands. See [requirements.md](requirements.md) for the submission checklist.
