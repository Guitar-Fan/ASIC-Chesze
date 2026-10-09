# Hack Club ASIC Plan

This plan covers two designs for the Hack Club GF180MCU shared-chip program.
The target is a tile of approximately `160 x 100 um` on the shared chip.

## Overall milestones

- [ ] Read the Hack Club submission requirements and confirm current deadlines.
- [ ] Create a separate public GitHub repository for each design.
- [ ] Keep each design small enough for the shared-chip tile and available I/O.
- [ ] Use the Tiny Tapeout GF180 Verilog template or Hack Club's required template
      when the submission instructions require its file structure and workflows.
- [ ] Keep a short engineering log for decisions, test results, and failures.

## Design 1: FPGA-qualified design

### Choose and specify the design

- [ ] Choose one small, understandable digital circuit.
- [ ] Define its clock, reset behavior, inputs, outputs, and expected behavior.
- [ ] Decide how the design maps to the available tile I/O.
- [ ] Write a short interface specification before implementing the RTL.

### Build the repository

- [ ] Create a public GitHub repository from the appropriate GF180/Tiny Tapeout
      template.
- [ ] Add the RTL source under the template's expected source directory.
- [ ] Add the simulation testbench and test vectors.
- [ ] Add the project metadata and configuration required by the template.
- [ ] Commit early and keep the repository reproducible from a clean checkout.

### Simulate and validate

- [ ] Run the testbench with Icarus Verilog or the template's simulator command.
- [ ] Inspect the generated waveform in GTKWave.
- [ ] Test reset, normal operation, boundary cases, and invalid or idle inputs.
- [ ] Confirm that the waveform matches the interface specification.
- [ ] Fix failures before beginning physical implementation.

### Run the physical flow

- [ ] Install and enable the current GF180MCU PDK with Ciel.
- [ ] Run the repository's GitHub Actions workflows.
- [ ] Confirm synthesis completes with Yosys.
- [ ] Confirm floorplanning, placement, CTS, and routing complete.
- [ ] Confirm the layout fits the tile dimensions and I/O constraints.
- [ ] Confirm DRC and LVS pass according to the template's checks.
- [ ] Inspect the generated gate/layout preview and archive the run results.

### FPGA submission

- [ ] Test the design on the IcePi Zero FPGA board when available.
- [ ] Compare FPGA behavior with the simulation waveform.
- [ ] Document the board setup, pin mapping, test procedure, and results.
- [ ] Publish the design write-up somewhere outside GitHub.
- [ ] Submit the first-design FPGA form:
      <https://forms.hackclub.com/asic-fpga>
- [ ] Save the submission confirmation and any requested follow-up details.

## Design 2: shared-chip design

### Plan the second design

- [ ] Choose a distinct design that is still small enough for one tile.
- [ ] Define the interface and expected behavior before writing RTL.
- [ ] Decide whether the design needs a carrier board or external components.
- [ ] Estimate tile area, clock speed, reset requirements, and test strategy.

### Build and verify

- [ ] Create a second public GitHub repository using the required template.
- [ ] Add the RTL, testbench, metadata, and configuration.
- [ ] Run simulation and inspect the waveform in GTKWave.
- [ ] Test reset, normal operation, boundary cases, and idle behavior.
- [ ] Run every repository workflow successfully.
- [ ] Run synthesis, place-and-route, DRC, and LVS for GF180MCU.
- [ ] Confirm the final layout fits within `160 x 100 um` and the available I/O.
- [ ] Test the second design on the FPGA board.
- [ ] Record the FPGA test results and compare them with simulation.

### Prepare the shared-chip submission

- [ ] Publish the second design write-up outside GitHub.
- [ ] Include the design purpose, interface, verification evidence, physical
      preview, FPGA results, and known limitations.
- [ ] Confirm the first and second designs have both worked on the FPGA.
- [ ] Design and document a carrier board if the second design needs one.
- [ ] Apply for the carrier-board grant if needed.
- [ ] Submit the shared-chip form:
      <https://forms.hackclub.com/asic-chip>
- [ ] Save the submission confirmation and retain the final repository state.

## Workspace commands

Start the current toolchain:

```bash
cd /config/workspace/ASIC-Chesze/librelane
nix develop
```

Check the GF180 PDK status:

```bash
ciel ls --pdk-family gf180mcu
```

Install the newest available GF180 release if none is installed:

```bash
GF180_VERSION="$(ciel ls-remote --pdk-family gf180mcu | head -1)"
ciel fetch --pdk-family gf180mcu "$GF180_VERSION"
ciel enable --pdk-family gf180mcu "$GF180_VERSION"
```

Run a design from its configuration file:

```bash
librelane /path/to/design/config.json
```

## Completion gate

A design is ready to submit only when its repository contains a reproducible
simulation, GTKWave evidence, passing workflows, a successful physical flow,
and a public write-up. The second shared-chip submission additionally requires
both designs to have been successfully tested on the FPGA.