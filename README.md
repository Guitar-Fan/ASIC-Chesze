# ASIC-Chesze

Small GF180MCU digital ASIC projects targeting a maximum die area of
`160 x 100 µm` (`100 x 160 µm` when rotated).

## Repository layout

```text
.
├── librelane/             # Pinned LibreLane 3.0.16 toolchain source
├── majority_vote/
│   ├── src/               # Synthesizable SystemVerilog
│   ├── verify/            # Self-checking testbench
│   ├── config.json        # GF180MCU physical-flow configuration
│   └── results/           # Final outputs from the reference run
├── plan.md                # Project and submission checklist
└── terminal.md            # Toolchain commands
```

Generated simulation files and complete LibreLane `runs/` directories are
ignored. Keep source, configuration, verification, and selected final signoff
artifacts in Git rather than every intermediate flow file.

See `terminal.md` for environment setup and flow commands.
