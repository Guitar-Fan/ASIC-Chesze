# ASIC Design Terminal Commands

These commands are for the current Spaces environment.

## Start the LibreLane toolchain

```bash
cd /config/workspace/ASIC-Chesze/librelane
nix develop
```

The prompt should change to something like:

```text
[nix-shell:~/workspace/ASIC-Chesze/librelane]$
```

All commands below assume that this shell is active.

## Verify the tools

```bash
librelane --version
yosys -V
openroad -version
magic -version
klayout -v
netgen -batch lvs
iverilog -V
verilator --version
ciel --version
```

Expected LibreLane version in this environment: `v3.0.16`.

This shell provides the open-source CAD flow: Yosys synthesis, OpenROAD
place-and-route, Magic and KLayout layout/DRC, Netgen LVS, plus Icarus Verilog
and Verilator for RTL simulation and linting.

## Install and enable GF180MCU

Check whether a GF180 PDK is already installed:

```bash
ciel ls --pdk-family gf180mcu
```

If it reports `No PDKs installed`, select the newest available release and
install it. The first command prints release identifiers, newest first:

```bash
GF180_VERSION="$(ciel ls-remote --pdk-family gf180mcu | head -1)"
ciel fetch --pdk-family gf180mcu "$GF180_VERSION"
ciel enable --pdk-family gf180mcu "$GF180_VERSION"
ciel output --pdk-family gf180mcu
```

LibreLane can then target the enabled GF180 variant in its configuration, for
example:

```json
{
	"DESIGN_NAME": "top",
	"VERILOG_FILES": "dir::src/top.v",
	"CLOCK_PORT": "clk",
	"CLOCK_PERIOD": 20.0,
	"PDK": "gf180mcuC"
}
```

The PDK is not installed by `nix develop`; it is a separate Ciel download.

## Run the LibreLane smoke test

```bash
librelane --log-level ERROR --condensed --show-progress-bar --smoke-test
```

The smoke test is a Sky130 example. For GF180 readiness, run a real design
with `PDK: "gf180mcuC"` after installing the PDK above.

## Run the example design

```bash
librelane --run-example spm
```

## Run a project design

From the LibreLane directory, pass the design configuration file:

```bash
librelane /path/to/design/config.json
```

The default flow is `Classic`. To select it explicitly:

```bash
librelane --flow Classic /path/to/design/config.json
```

LibreLane writes results to a `runs/` directory in the design directory.

## Inspect the last run

Open the final layout in KLayout:

```bash
librelane --last-run --flow OpenInKLayout /path/to/design/config.json
```

Open the design in OpenROAD:

```bash
librelane --last-run --flow OpenInOpenROAD /path/to/design/config.json
```

## Leave the toolchain shell

```bash
exit
```

## If a new terminal does not find Nix

The rootless Nix launcher is installed at `~/.local/bin/nix`. Reload the shell
configuration or add the path temporarily:

```bash
source ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

The LibreLane binary cache is configured in `~/.bashrc` to avoid rebuilding the
EDA tools locally.