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
```

Expected LibreLane version in this environment: `v3.0.16`.

## Run the LibreLane smoke test

```bash
librelane --log-level ERROR --condensed --show-progress-bar --smoke-test
```

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