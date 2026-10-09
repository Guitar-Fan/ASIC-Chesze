# ASIC-Chesze Context Handoff

This file summarizes the useful context from the chat and the current Hack Club
Spaces workspace.

## Environment

- Platform: `spaces.hackclub.com`, not GitHub Codespaces.
- Workspace: `/config/workspace/ASIC-Chesze`.
- User: `abc` in a restricted Linux container.
- Docker is unavailable in the base terminal. The Docker extension does not
  install a Docker engine, and `sudo` is blocked by `no new privileges`.
- Nix is installed rootlessly through `nix-portable`.
- Nix executable: `/config/.local/bin/nix`.
- Nix version: `2.20.6`.
- The shell startup configuration contains the rootless Nix path and the FOSSi
  Foundation binary cache settings.

## Repository structure

```text
ASIC-Chesze/
├── .devcontainer/devcontainer.json
├── README.md
├── context1.md
├── plan.md
├── terminal.md
├── librelane/
└── majority_vote/
    ├── config.json
    ├── src/majority_vote.sv
    ├── verify/majority_vote_tb.sv
    ├── majority_vote.vcd
    ├── majority_vote.vvp
    └── runs/
```

## Devcontainer history

`.devcontainer/devcontainer.json` was added and committed in commit
`c6c7f5d` with the name `ASIC Design Environment`. It specifies the Universal
devcontainer image, Docker-in-Docker feature, and these VS Code extensions:

- `mcu-debug.memory-view`
- `mshr-h.veriloghdl`

This configuration is not what creates the current Hack Club Spaces runtime;
Spaces is separate from GitHub Codespaces.

## Nix and LibreLane

Enter the current ASIC toolchain with:

```bash
cd /config/workspace/ASIC-Chesze/librelane
nix develop
```

Verified versions inside the development shell:

```text
LibreLane v3.0.16
Yosys 0.62
Ciel v2.4.0
```

The shell also provides:

- OpenROAD for place-and-route
- Magic for layout and DRC
- KLayout for layout viewing and related checks
- Netgen for LVS
- Icarus Verilog and Verilator for simulation/linting
- GTKWave, although this Spaces container has no `DISPLAY`/X11 GUI

The FOSSi binary cache is configured with:

```text
https://nix-cache.fossi-foundation.org
```

The cache avoids building the large EDA dependency set locally.

## Important Nix recovery detail

LibreLane was originally a nested Git repository. It was later made part of
the parent `ASIC-Chesze` repository as regular files. That changed how Nix
resolved `self` and caused this error:

```text
cp: cannot create directory 'librelane/.github': Permission denied
do not know how to unpack source archive ...
```

The previous nested Git metadata was preserved at:

```text
/tmp/ASIC-Chesze-librelane-git-01ddb25
```

The working recovery was:

1. Restore that directory to `librelane/.git`.
2. Keep the original LibreLane flake setting:

```nix
librelane = callPythonPackage ./default.nix {
  flake = self;
};
```

After restoring the nested Git identity, `cd librelane && nix develop` worked
again. Do not remove `librelane/.git` unless the flake is redesigned for the
parent repository layout.

## GF180MCU PDK

GF180MCU is the process design kit needed for physical implementation on the
Hack Club/wafer.space GF180 run. It supplies technology rules, standard cells,
layers, models, and DRC/LVS data. It is separate from the Nix toolchain.

Installed and enabled PDK:

```text
Family: gf180mcu
Release: 2026.10.01
Version ID: 1e3554706ddbb2529193bdabbc7128296f3cb44a
```

PDK root:

```text
/config/.ciel/ciel/gf180mcu
```

Useful commands inside `nix develop`:

```bash
ciel ls --pdk-family gf180mcu
ciel output --pdk-family gf180mcu
ciel path --pdk-family gf180mcu 1e3554706ddbb2529193bdabbc7128296f3cb44a
```

For hardening, activate and export the PDK in the same shell invocation as
LibreLane:

```bash
ciel enable --pdk-family gf180mcu 1e3554706ddbb2529193bdabbc7128296f3cb44a
export PDK_ROOT=/config/.ciel/ciel/gf180mcu
export PDK=gf180mcuC
```

## Majority-vote design

RTL file:

```text
majority_vote/src/majority_vote.sv
```

The module has three inputs and one output:

```text
vote_a, vote_b, vote_c -> majority
```

The combinational majority function is true when at least two of the three
inputs are true. Input order does not matter.

Testbench:

```text
majority_vote/verify/majority_vote_tb.sv
```

The testbench exhaustively checks all eight input combinations and writes:

```text
majority_vote/majority_vote.vcd
```

Verified simulation result:

```text
Passed 8 majority-vote tests
```

Run the simulation independently with:

```bash
cd /config/workspace/ASIC-Chesze/majority_vote
nix shell nixpkgs#iverilog --command \
  iverilog -g2012 -o /tmp/majority_vote.vvp \
  src/majority_vote.sv verify/majority_vote_tb.sv
vvp /tmp/majority_vote.vvp
```

GTKWave is a native GUI application. Port forwarding alone does not display it,
and this container has no X11/Wayland display. Download the VCD and open it on
a computer with a GUI if waveform inspection is needed.

## LibreLane configuration

Configuration file:

```text
majority_vote/config.json
```

Current settings:

```json
{
  "DESIGN_NAME": "majority_vote",
  "VERILOG_FILES": ["dir::src/majority_vote.sv"],
  "PDK": "gf180mcuC",
  "CLOCK_PERIOD": 10.0,
  "CLOCK_PORT": null,
  "FP_SIZING": "absolute",
  "DIE_AREA": "0 0 160 100"
}
```

The design is combinational, so no real clock port exists. LibreLane used a
virtual clock and emitted timing warnings about that. Those warnings did not
prevent the physical flow from completing.

## Successful physical run

Run directory:

```text
majority_vote/runs/RUN_2026-10-09_21-46-21
```

The successful command was run from inside `nix develop` with Ciel activation
and PDK variables in the same shell:

```bash
cd /config/workspace/ASIC-Chesze/librelane
nix develop --command bash -lc '\
  ciel enable --pdk-family gf180mcu 1e3554706ddbb2529193bdabbc7128296f3cb44a >/dev/null && \
  export PDK_ROOT=/config/.ciel/ciel/gf180mcu && \
  export PDK=gf180mcuC && \
  cd /config/workspace/ASIC-Chesze/majority_vote && \
  librelane --log-level INFO config.json'
```

Primary outputs:

- GDSII: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/gds/majority_vote.gds`
- Layout preview: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/render/majority_vote.png`
- DEF: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/def/majority_vote.def`
- LEF: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/lef/majority_vote.lef`
- SPICE: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/spice/majority_vote.spice`
- LVS report: `majority_vote/runs/RUN_2026-10-09_21-46-21/70-netgen-lvs/reports/lvs.netgen.rpt`
- Metrics: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/metrics.json`

Reported results:

```text
Antenna: Passed
LVS: Passed
Magic DRC: Passed
Routing DRC: Passed
Flow complete: 80/80 stages
```

KLayout’s dedicated DRC stage was skipped because `KLAYOUT_DRC_RUNSET` was
unset for the GF180MCU PDK. The flow warned that the KLayout DRC metric was not
reported. This should be resolved or explicitly accepted by the target Hack
Club/Tiny Tapeout submission workflow before treating the design as submission
ready.

Other non-blocking warnings included virtual-clock warnings, no CTS clock for
the combinational design, missing `PNR_SDC_FILE` and `SIGNOFF_SDC_FILE`, and
missing `VSRC_LOC_FILES` for IR-drop accuracy.

## Hack Club submission context

The stated program targets teenagers aged 13–18 and a shared GF180MCU chip with
tiles around `160 x 100 um`. The first design is intended for FPGA validation;
the second design can be submitted to the shared chip after both designs work
on the FPGA. A public write-up outside GitHub is required.

Expected submission evidence includes:

- Complete public design repository
- RTL and testbench
- Simulation and GTKWave evidence
- Passing repository workflows
- Physical layout preview
- Synthesis, place-and-route, DRC, and LVS results
- FPGA testing
- Public write-up outside GitHub

The Hack Club guidance also references the Tiny Tapeout GF180 template and OSS
CAD tools. Tiny Tapeout is relevant as a workflow/template, but the current
Spaces workflow uses LibreLane, Nix, Ciel, and the GF180MCU PDK.

## Current status and remaining work

Completed:

- Rootless Nix installation
- LibreLane development shell recovery
- OSS-CAD tool availability
- GF180MCU PDK installation and activation
- Majority-vote RTL and exhaustive simulation
- GF180 physical hardening run
- GDS, DEF, LEF, SPICE, layout preview, Magic DRC, LVS, and antenna outputs

Still needed before submission:

- Adapt the module to the exact Hack Club/Tiny Tapeout top-level I/O template.
- Confirm that the generated layout and pin mapping meet the submission wrapper
  and shared-chip multiplexing requirements.
- Resolve or document the missing KLayout GF180 DRC runset requirement.
- Run the required repository GitHub Actions workflows.
- Test the design on the IcePi Zero FPGA board.
- Publish the required external write-up.
- Follow the current Hack Club submission form and deadline instructions.

Current untracked/generated workspace items include the majority-vote simulation
outputs, `majority_vote/config.json`, and `majority_vote/runs/`. Review these
before committing; large run directories may be better archived or excluded
from Git while retaining the key reports and final GDS.