# ASIC-Chesze Hack Club Submission Requirements

This document describes the repository structure and files needed to reorganize
`Guitar-Fan/ASIC-Chesze` into a Tiny Tapeout-style ASIC project similar to
`KaiPereira/SPI-Slave-ASIC`.

Hack Club's ASIC program currently expects a design made with the Tiny Tapeout
GlobalFoundries template, a project write-up, FPGA verification, and evidence
that the design can proceed through the physical-design flow. The design should
also be small enough to fit the allocated tile. [Hack Club ASIC requirements](https://asic.hackclub.com/)

> This checklist is based on the current Hack Club ASIC guidance, the structure
> of `KaiPereira/SPI-Slave-ASIC`, and the existing `plan.md` in this repository.
> The official Hack Club submission instructions should be checked again before
> submitting because requirements may change.

---

## 1. Required top-level structure

The repository should eventually resemble this:

```text
ASIC-Chesze/
├── .github/
│   └── workflows/
│       ├── test.yml
│       ├── gds.yml
│       ├── docs.yml
│       └── fpga.yml
├── .gitignore
├── LICENSE
├── README.md
├── info.yaml
├── docs/
│   └── info.md
├── src/
│   ├── Makefile
│   ├── tt_um_guitarfan_<design_name>.v
│   ├── _tt_fpga_top.v
│   ├── top.v
│   ├── config.json
│   ├── icepi-zero.lpf
│   └── bitstream.bit
├── test/
│   ├── Makefile
│   ├── README.md
│   ├── requirements.txt
│   ├── tb.v
│   ├── test.py
│   └── tb.gtkw
├── build/
│   └── .gitkeep
├── bom.csv
├── plan.md
└── engineering-log.md
```

The exact workflow filenames may differ depending on the Tiny Tapeout template
version. Start from the current Tiny Tapeout GF180MCU template rather than
manually copying another project's workflows.

---

## 2. Required project metadata

### `info.yaml`

Create an `info.yaml` file in the repository root using the Tiny Tapeout
metadata format.

It must contain:

- Project title
- Author name
- Optional Discord username
- One-line project description
- HDL language
- Clock frequency
- Tile size
- Unique top-module name
- List of every source file in `src/`
- Complete Tiny Tapeout pinout
- `yaml_version`

The top-level module name must start with `tt_um_`.

Recommended naming:

```yaml
top_module: "tt_um_guitarfan_majority_vote"
```

The name should be unique and should match the module declaration in the RTL
source.

Example source-file section:

```yaml
source_files:
  - "tt_um_guitarfan_majority_vote.v"
```

Every file listed in `source_files` must actually exist in `src/`.

---

## 3. RTL source files

Create a root-level `src/` directory for the design source.

At minimum, include:

```text
src/
├── tt_um_guitarfan_<design_name>.v
├── config.json
└── Makefile
```

The main RTL file must:

- Use synthesizable Verilog or SystemVerilog.
- Contain the module named in `info.yaml`.
- Use the Tiny Tapeout standard port interface.
- Define all clock, reset, input, output, and bidirectional pins clearly.
- Avoid unsupported simulation-only constructs.
- Avoid undeclared or floating inputs.
- Document the behavior of each pin.
- Be small enough for the intended GF180MCU tile.

The project currently has RTL-related content under
`majority_vote/src/`. Move or copy the final submission RTL into the
Tiny Tapeout-style root-level `src/` directory, or ensure the chosen template
supports the existing location and update all configuration files consistently.

The RTL should have a structure similar to:

```verilog
module tt_um_guitarfan_majority_vote (
    input  wire [7:0]  ui_in,
    output wire [7:0]  uo_out,
    input  wire [7:0]  uio_in,
    output wire [7:0]  uio_out,
    output wire [7:0]  uio_oe,
    input  wire        ena,
    input  wire        clk,
    input  wire        rst_n
);

    // Design implementation

endmodule
```

Use the exact port interface required by the selected Tiny Tapeout template.

---

## 4. Build and physical-design configuration

The `src/` directory should contain the configuration required to run the
physical-design flow:

```text
src/
├── config.json
├── Makefile
└── <RTL source files>
```

`config.json` must:

- Identify the correct top module.
- List the correct RTL source files.
- Use the GF180MCU PDK.
- Define clock and reset constraints where applicable.
- Define the intended die or tile dimensions.
- Use paths that work from a clean checkout.

The configuration currently located at:

```text
majority_vote/config.json
```

should be reviewed and either adapted to the selected Tiny Tapeout template or
replaced with the template's expected configuration.

Do not leave configuration pointing to old paths after reorganizing the
repository.

---

## 5. Testbench and simulation

Create a root-level `test/` directory.

Required or strongly recommended files:

```text
test/
├── Makefile
├── README.md
├── requirements.txt
├── tb.v
├── test.py
└── tb.gtkw
```

The testbench must verify:

- Reset behavior
- Normal operation
- Expected output values
- Boundary cases
- Idle inputs
- Invalid or unused input combinations where applicable
- Clock behavior
- Any state-machine transitions
- The behavior of all pins used by the design

The `test/Makefile` must list every source file through
`PROJECT_SOURCES`.

The testbench must instantiate the exact top-level module named in
`info.yaml`.

Example commands that should work from `test/`:

```bash
make -B
gtkwave tb.fst tb.gtkw
```

If gate-level simulation is supported, document how to run it:

```bash
make -B GATES=yes
```

The testbench should produce a waveform file such as `tb.fst` or `tb.vcd`.
Commit a GTKWave configuration file such as `test/tb.gtkw` so reviewers can
quickly inspect important signals.

---

## 6. FPGA verification

Because the Hack Club ASIC process uses FPGA testing before shared-chip
submission, include the FPGA files in `src/` or in a clearly named FPGA
directory.

Recommended files:

```text
src/
├── _tt_fpga_top.v
├── top.v
├── icepi-zero.lpf
├── bitstream.bit
└── Makefile
```

Document:

- FPGA board model
- FPGA top-level module
- Pin assignments
- Clock frequency
- Reset behavior
- Programming instructions
- External wiring
- Test procedure
- Expected results
- Actual results
- Any known limitations

The repository should include evidence that the FPGA behavior matches the RTL
simulation.

---

## 7. GitHub Actions

Add a `.github/workflows/` directory containing the workflows required by the
selected Tiny Tapeout template.

The workflows should cover, where supported:

- RTL simulation
- Documentation validation
- GDS or physical-design generation
- FPGA build

Every workflow should:

- Run successfully from a clean checkout.
- Use supported action versions.
- Avoid hard-coded local paths.
- Install or select the correct GF180MCU PDK.
- Fail when tests or required checks fail.

Do not copy workflows blindly from another repository. Confirm that the
workflow paths, module names, PDK version, and source files match
`ASIC-Chesze`.

---

## 8. Documentation files

### `README.md`

The root README must explain:

1. What the ASIC design does.
2. Why the project was made.
3. How the design works.
4. The clock and reset behavior.
5. The complete pinout.
6. How to run the RTL simulation.
7. How to view waveforms.
8. How to run gate-level simulation, if supported.
9. How to build the FPGA image.
10. How to program and test the FPGA.
11. How to run the physical-design flow.
12. Current synthesis, area, timing, DRC, and LVS status.
13. Known limitations.
14. Links to evidence, images, waveforms, and write-up material.

Include images or visual evidence where possible:

- Block diagram
- Simulation waveform
- FPGA setup
- Physical-layout preview
- GDS viewer preview
- Relevant test results

The README should be written in your own words and accurately describe work
that you personally completed.

### `docs/info.md`

Use `docs/info.md` for a short technical project page containing:

- Project purpose
- Design overview
- Pin descriptions
- Expected behavior
- Verification status
- Physical-design status
- FPGA status
- Known issues

### `engineering-log.md`

Create an engineering log with dated entries for:

- Design decisions
- RTL changes
- Simulation results
- Failed approaches
- PDK/toolchain issues
- FPGA tests
- Physical-design results
- DRC/LVS problems
- Fixes and remaining work

This helps demonstrate that the project was developed incrementally and is
reproducible.

---

## 9. License and repository hygiene

Add:

```text
LICENSE
.gitignore
```

The `.gitignore` should exclude generated files such as:

```text
*.fst
*.vcd
*.log
*.tmp
__pycache__/
.pytest_cache/
build/
runs/
*.pyc
.env
```

Do not ignore files that are required as submission evidence. For example,
final waveforms, screenshots, reports, or layout previews may need to be
committed in a clearly named documentation or evidence directory.

Do not commit:

- Secrets
- Personal access tokens
- Local absolute paths
- Unnecessary tool caches
- Huge temporary build directories
- Unrelated experiments
- Generated files that cannot be reproduced

---

## 10. BOM and reproducibility

Create a root-level `bom.csv` if the final design requires external hardware,
components, a carrier board, or FPGA test hardware.

The BOM should include:

```csv
Part,Quantity,Unit Price,Total Price,Purchase Link,Notes
```

Even if the project is primarily an ASIC, document any:

- FPGA board
- Logic analyzer
- Oscillator
- Resistors
- Capacitors
- Connectors
- Level shifters
- Carrier-board components
- External test equipment

The README should also explain the required hardware and estimated total cost.

Hack Club's general hardware guidance emphasizes that repositories should
contain the source files, dependencies, documentation, and other files needed
for another person to reproduce the project. [Hack Club submission guidance](https://id4mt4glsynz41ifbnu9cysl.a.selfhosted.hackclub.com/docs/submitting-design)

---

## 11. Recommended final structure

A cleaner final organization for this repository is:

```text
ASIC-Chesze/
├── .devcontainer/
├── .github/
│   └── workflows/
├── docs/
│   ├── info.md
│   ├── waveforms/
│   ├── layout/
│   └── images/
├── src/
│   ├── tt_um_guitarfan_<design_name>.v
│   ├── _tt_fpga_top.v
│   ├── top.v
│   ├── config.json
│   ├── Makefile
│   ├── icepi-zero.lpf
│   └── bitstream.bit
├── test/
│   ├── Makefile
│   ├── README.md
│   ├── requirements.txt
│   ├── tb.v
│   ├── test.py
│   └── tb.gtkw
├── build/
├── bom.csv
├── engineering-log.md
├── info.yaml
├── LICENSE
├── README.md
├── plan.md
└── .gitignore
```

Keep the LibreLane installation/toolchain separate from the design submission
files if possible. A full toolchain checkout should not obscure the actual ASIC
project source.

---

## 12. Migration from the current repository

The current repository contains:

```text
majority_vote/
├── config.json
├── results/
├── src/
└── verify/
```

Migrate it as follows:

| Current location | Recommended destination |
|---|---|
| `majority_vote/src/` | `src/` |
| `majority_vote/config.json` | `src/config.json` or the location required by the selected template |
| `majority_vote/verify/` | `test/` |
| `majority_vote/results/` | `docs/`, `build/`, or a deliberately curated evidence directory |
| `plan.md` | Keep at repository root |
| `librelane/` | Keep separate as toolchain support, or replace with a documented template-based flow |

Before moving files, identify:

- The actual top-level RTL module name.
- All RTL source files.
- Existing testbench files.
- Existing simulation commands.
- Existing LibreLane configuration paths.
- Existing generated reports.
- Which results are reproducible and which are only temporary artifacts.

After moving files, update every reference in:

- `info.yaml`
- `config.json`
- `src/Makefile`
- `test/Makefile`
- Testbench module instantiations
- GitHub Actions workflows
- README commands
- FPGA build files

---

## 13. Submission readiness checklist

### Repository structure

- [ ] Repository is public.
- [ ] Repository is based on the correct Tiny Tapeout GF180MCU template.
- [ ] `src/` contains the final RTL.
- [ ] `test/` contains the testbench and simulation configuration.
- [ ] `info.yaml` exists and is valid.
- [ ] `.github/workflows/` contains the required workflows.
- [ ] `README.md` explains setup, usage, testing, and results.
- [ ] `docs/` contains supporting documentation.
- [ ] `LICENSE` and `.gitignore` exist.
- [ ] No secrets or personal machine paths are committed.

### RTL and metadata

- [ ] Top module name starts with `tt_um_`.
- [ ] Top module name matches `info.yaml`.
- [ ] Every source file listed in `info.yaml` exists.
- [ ] Pinout is documented.
- [ ] Clock frequency is documented.
- [ ] Reset polarity and behavior are documented.
- [ ] Tile size is documented.
- [ ] Unused pins are safely handled.

### Verification

- [ ] RTL simulation passes.
- [ ] Reset is tested.
- [ ] Normal operation is tested.
- [ ] Boundary cases are tested.
- [ ] Idle and invalid inputs are tested.
- [ ] Waveform is generated.
- [ ] GTKWave configuration is included.
- [ ] Gate-level simulation is run if available.
- [ ] FPGA build succeeds.
- [ ] FPGA behavior matches simulation.
- [ ] Test results are documented.

### Physical implementation

- [ ] GF180MCU PDK is configured.
- [ ] Synthesis succeeds.
- [ ] Floorplanning succeeds.
- [ ] Placement succeeds.
- [ ] Clock-tree synthesis succeeds if applicable.
- [ ] Routing succeeds.
- [ ] Timing is checked.
- [ ] Area fits the allocated tile.
- [ ] DRC passes.
- [ ] LVS passes.
- [ ] Layout preview is inspected.
- [ ] Final reports are archived or linked.

### Submission materials

- [ ] Public project write-up is complete.
- [ ] Design purpose is explained.
- [ ] Interface and pinout are explained.
- [ ] Simulation evidence is included.
- [ ] FPGA evidence is included.
- [ ] Physical-layout evidence is included.
- [ ] Known limitations are disclosed.
- [ ] Engineering log is up to date.
- [ ] Submission forms are completed.
- [ ] Submission confirmation is saved.

---

## 14. Important caution

The `KaiPereira/SPI-Slave-ASIC` repository is a useful example of organization,
but it is not automatically the authoritative template for the current
submission. Use the current Tiny Tapeout GF180MCU template and Hack Club
instructions as the source of truth.

Do not copy Kai's RTL, documentation, images, workflows, or project metadata as
your own. Use the structure as inspiration, keep attribution where needed,
and ensure that all design work and test results describe `ASIC-Chesze`.