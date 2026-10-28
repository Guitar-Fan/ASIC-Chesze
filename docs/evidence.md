# Evidence Index

This directory is reserved for curated submission evidence. Do not commit full
LibreLane `runs/` trees or tool caches.

## Existing reference evidence

The earlier majority-vote GF180 run produced:

- Layout preview: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/render/majority_vote.png`
- GDSII: `majority_vote/runs/RUN_2026-10-09_21-46-21/final/gds/majority_vote.gds`
- LVS report: `majority_vote/runs/RUN_2026-10-09_21-46-21/70-netgen-lvs/reports/lvs.netgen.rpt`

These are reference artifacts for the old majority-vote design, not signoff
artifacts for the active chess-clock design.

## Active design evidence

Add these only after the chess-clock flow passes:

- RTL waveform and GTKWave setup
- FPGA test evidence
- Physical-layout preview
- Final GDSII
- DRC, LVS, antenna, and timing reports
- Tool versions and reproducible commands
