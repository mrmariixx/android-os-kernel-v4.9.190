# Test results and validation record

## Current recorded results

| Check | Result | Meaning |
|---|---|---|
| Project kernel version from root Makefile | 4.19.191 | Confirmed repository is not target 4.9.190. |
| Exact US105 touchscreen profile in Flitsmeister source | Found | Reference profile exists in a different 4.19.191 tree; no target backport done. |
| `tb8768p1_64_bsp` in Flitsmeister and Lenovo candidates | Found | Platform-name/board-family evidence only. |
| Exact `us105_fx_hx8279_boe_wuxga_ips_101` implementation | Not found in examined source searches | Display implementation remains blocked. |
| Stock config/report in this repository at the supplied paths | Not found in GitHub lookup | Request contains hardware facts and config excerpts, but full config evidence is unavailable here. |
| 4.9.190 MID1020L kernel build | Not run | No verified source tree/toolchain inputs available. |
| Device boot, panel, touch, Wi-Fi, audio, suspend/resume tests | Not run | No hardware session; no boot image or safe recovery path. |
| Partition writes/unlock | None | Not attempted. |

Search tools can return incomplete results. A “not found” above means not found
in examined public search results/candidate paths, not proof the code does not
exist in private, unindexed or unpublished sources.

## Repeatable local checks

```sh
bash tools/validate-mid1020l.sh
bash -n tools/mid1020l-audit.sh tools/mid1020l-fetch-sources.sh tools/validate-mid1020l.sh tools/build-kernel.sh
```

The validation script reports missing prerequisites as blocked. Run the build
script only after supplying an independently verified 4.9.190 source and stock
config as described in `KERNEL_BUILD.md`.

No static or compile test in this record is represented as a successful device
boot.
