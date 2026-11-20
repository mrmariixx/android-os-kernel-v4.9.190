# MID1020L kernel source audit

Audit date: 2026-11-20  
Target evidence supplied by owner: eSTAR MID1020L / board US105I / product
`tb8768p1_64_bsp`, Android 10, stock Linux `4.9.190`, MTK platform property
`MT6765`, hardware property `MT8768`, HX8279 BOE 1920x1200 panel and US105
GSLX68X touchscreen. This report separates those supplied facts from what was
verified in public source repositories.

## Decision

**No port patch or device DTS has been started.** No public source located so
far is proven to be the exact MID1020L 4.9.190 BSP with the device's panel,
DTB/DTBO and complete stock configuration. The user's gate against beginning a
port until a sufficiently verified base exists is therefore still in effect.

Strongest references:

1. `flitsmeister/android-os-kernel`, commit
   `ed306e55b1ff9a96980edde7998fdff792b4b04e`, kernel **4.19.191**. It has an
   ARM64 `tb8768p1_64_bsp_defconfig`, board DTS and an exact
   `US105_MJK_1298FPC_WUXGANL_101` GSLX68X profile. This is hardware-family
   evidence, not proof of MID1020L compatibility and not a 4.9 base.
2. `NT-Project/android_kernel_lenovo_tb8505x`, commit
   `61af5d9350b3f670a1548b7f66b7ab4181e3923e`, kernel **4.9.200**. Its defconfig
   and DTS name `tb8768p1_64_bsp`, use `CONFIG_MTK_PLATFORM="mt6765"`, and show
   the same GSLX68X Kconfig family. It is the closest candidate in kernel
   series/platform identifiers, but is a Lenovo tablet tree at 4.9.200. The
   source and stock board tables, kernel config, and DTS still require a
   file-by-file comparison; the matching project string alone does not make
   this MID1020L's tree.

The repository branch used by this project is itself kernel **4.19.191**
(`Makefile`, VERSION/PATCHLEVEL/SUBLEVEL). `kernel/stock.config` and
`evidence/report.txt` were not found at the repository root or under the
provided paths when inspected. The configuration and report facts in the
request remain owner-supplied evidence, not locally present source files.

## Exact-string findings

| Query | Finding | Interpretation |
|---|---|---|
| `US105_MJK_1298FPC_WUXGANL_101` | Present in the Flitsmeister GSLX68X tree (`mid/` profile, `tp_list.h` include/selection, `us105` project array). | Exact touchscreen profile evidence. It is a data header using the driver’s `struct fw_data`, config-ID and profile selection infrastructure; do not cherry-pick only the header without proving the target driver's matching support. |
| `us105_fx_hx8279_boe_wuxga_ips_101` | No exact source/profile found in examined candidate code search. | Panel driver is unresolved. |
| `tb8768p1_64_bsp` | Present in Flitsmeister and NT-Project 4.19/4.9 source defconfig and DT file naming. | Strong platform lineage evidence, but not exact device proof. |
| `HX8279` | Multiple Flitsmeister LCM drivers exist, e.g. US717/US720/US828 variants. | Related controller name is insufficient to identify panel init, timing, power, or GPIOs for US105. |
| `GSLX68X` | Flitsmeister has MediaTek GSLX68X driver family and exact US105 profile. | Useful reference; API/board dependencies need comparison with a real 4.9.190 source. |

Search results are not exhaustive (GitHub code search and public web indexes can
miss private, unindexed, deleted, or renamed sources). No exact public
MID1020L GPL archive was identified in this audit.

## Candidate repositories

| Repository / ref | Kernel | What was verified | Assessment / license note |
|---|---:|---|---|
| [flitsmeister/android-os-kernel](https://github.com/flitsmeister/android-os-kernel/tree/ed306e55b1ff9a96980edde7998fdff792b4b04e) `ed306e55b1ff9a96980edde7998fdff792b4b04e` | 4.19.191 | Exact `tb8768p1_64_bsp` defconfig/DTS references; `CONFIG_MTK_PLATFORM="mt6765"`; exact US105 touchscreen profile. Other HX8279 panel variants; not the supplied US105 FX BOE name. | Best device-family research reference. Not the target 4.9 kernel; stock hardware/config differences and 4.19-to-4.9 API/BSP differences make direct backport unsafe pending audit. GitHub API reports license `Other`; source files carry GPL notices. Preserve notices and verify complete license obligations before redistribution. |
| [NT-Project/android_kernel_lenovo_tb8505x](https://github.com/NT-Project/android_kernel_lenovo_tb8505x/tree/61af5d9350b3f670a1548b7f66b7ab4181e3923e) `61af5d9350b3f670a1548b7f66b7ab4181e3923e` | 4.9.200 | ARM64 `tb8768p1_64_bsp_defconfig`, project/platform identifiers and `tb8768p1_64_bsp.dts`; DTS contains Lenovo board pin/power/charger/audio configuration. | Closest 4.9 candidate by platform/project string, but 10 minor revisions newer and Lenovo's board. No exact US105 touch profile/panel match established here. Candidate comparator only. API reports `Other` license. |
| [Barracuda72/android_kernel_fplus_r570e_old](https://github.com/Barracuda72/android_kernel_fplus_r570e_old/tree/1718901c45f7d4db6ea793c6cd6cd44600c1aab9) `1718901c45f7d4db6ea793c6cd6cd44600c1aab9` | 4.9.119 | Makefile version is 4.9.119. | Different named F+ device; 71 minor revisions older; no MT6765/MT8768 or board evidence verified. Not a base. API reports `Other` license. |
| [mediatek-android-development/android_kernel_mediatek_mt6761-62-4.9](https://github.com/mediatek-android-development/android_kernel_mediatek_mt6761-62-4.9/tree/100227b164b750408d61e40e153ec10c49d48863) `100227b164b750408d61e40e153ec10c49d48863` | 4.9.117 | Repository description says Alps kernel for MT6761/MT6763/MT6765; root Makefile is 4.9.117. | Useful historical MTK 4.9 reference, but predates target by 73 minor revisions and not exact MT8768 product/BSP. Not a base. API reports `Other` license. |
| [LibreHU/android_kernel_autochips_ac8257_4.9](https://github.com/LibreHU/android_kernel_autochips_ac8257_4.9/tree/83fca99a8027cb85d70ebc3838f04859a40fd0f5) `83fca99a8027cb85d70ebc3838f04859a40fd0f5` | 4.9.117 | Makefile is 4.9.117; repository describes AutoChips AC8257 and is a fork of the MT6761/62/63/65 source family. | Both platform identity and version differ; comparator only. API reports `Other` license. |
| [TALPAD-BOOM-Developers/TALIH-PD2-Kernel](https://github.com/TALPAD-BOOM-Developers/TALIH-PD2-Kernel/tree/f07b78c03128c71ab9a6e5da0bfaad858281390b) `f07b78c03128c71ab9a6e5da0bfaad858281390b` | 4.19.191 | Makefile is 4.19.191; repository describes TALPAD PD2 and its build notes name MT8797. | Not target SoC/project and not target kernel series. Negative/control comparison only. README states GPL-2.0 WITH Linux-syscall-note; inspect file-level notices. |

The source acquisition helper pins these exact commits and clones to separate
`sources/` directories without overwriting existing paths. Run it from a
checkout of this branch with network access:

```sh
bash tools/mid1020l-fetch-sources.sh
```

The GitHub API only surfaced candidate metadata/file excerpts here; source
archives have not been downloaded in this session. The script is the
reproducible acquisition step. No candidate has been promoted to a build base.

## Configuration and hardware comparison

The owner-provided stock config facts indicate a legacy MediaTek display path:
`CONFIG_MTK_LCM=y`, `CONFIG_MTK_FB=y`, `CONFIG_DRM=y`, while
`CONFIG_MTK_LCM_DEVICE_TREE_SUPPORT` is unset. Therefore the source audit must
trace `CONFIG_CUSTOM_KERNEL_LCM` selection and LCM list/registration, not assume
upstream DRM panel support. The stock facts also indicate `CONFIG_MMC_MTK_PRO`,
`CONFIG_MTK_EMMC_SUPPORT`, MT6357 PMIC/charger, and the GSLX68X touchscreen.
These are configuration facts only; without the actual config and device tree,
they do not tell us the selected Wi-Fi chip/driver, audio machine route, touch
interrupt/reset wiring, LCD power resources, or panel command sequence.

| Area | Target evidence | Public reference result | Status |
|---|---|---|---|
| CPU/platform | ARM64, MT6765/MT8768 family, `tb8768p1_64_bsp` | Flitsmeister and Lenovo candidate project names/platform identifiers match | Strong family/board-name correlation, not exact MID1020L proof |
| Touch | US105 MJK 1298FPC WUXGANL 10.1; GSLX68X enabled | Exact profile and project registration found in Flitsmeister 4.19.191 source | High-value candidate data; cannot transplant independently of matching GSL driver and BSP APIs |
| Display | `us105_fx_hx8279_boe_wuxga_ips_101`, 1920x1200 | Several HX8279 variants but no exact US105 FX/BOE LCM implementation | Unresolved; do not infer timings, GPIOs, regulator, or reset sequence |
| Display framework | MTK LCM + MTK framebuffer in owner config | Candidate 4.19 tree includes MTK LCM and MTK FB | Framework family aligns; exact LCM option and registration absent for target |
| eMMC | eMMC; MTK eMMC support in owner config | Board-family candidate config includes MTK MMC/eMMC options; Lenovo DTS has MSDC nodes | Controller family is plausible; target DT storage/pin/voltage configuration absent |
| Wi-Fi | Not identified in available evidence | Flitsmeister generic defconfig excerpts disable vendor WLAN kernel drivers; Android vendor WLAN may be proprietary/out-of-tree | Chip, driver, module and firmware unknown; cannot claim compatible |
| Audio | MT6357 configuration reported | Candidate DTS has MTK audio pin states, but Lenovo-specific GPIOs/routes | Codec family evidence is insufficient to transplant route/pin settings |
| Device tree / DTBO | No stock DTB extraction or DTBO image | Candidate board DTS exists for other device tree/config combinations | Exact MID1020L DTS and overlay unavailable; fatal board bring-up blocker |
| Boot/firmware | No full boot image, DTBO, DTB, or verified full backup | Not provided by these source repositories | Cannot validate boot image format, kernel cmdline, modules, firmware, or rollback |

## Candidate differences and backport risk

* Stock is reported as 4.9.190. The Flitsmeister tree's 4.19.191 is a different
  kernel major/minor series; identical controller profile data does not make
  its MTK LCM or touchscreen implementation a safe drop-in.
* Lenovo's 4.9.200 shares the platform project string and has board DTS/defconfig
  naming evidence, making it more relevant for 4.9 BSP comparison than generic
  MT6765 trees. However, the board manufacturer/device, full defconfig, DTS
  overlays, pin assignments, panel, power rails, and BSP revision have not been
  matched to eSTAR US105I. A kernel build would not prove it boots the eSTAR.
* The 4.9.117 and 4.9.119 trees are older and/or different platforms. Their
  close kernel version alone is not compatibility evidence.
* The target BSP branch `alps-mp-q0.mp1-V9.138`, Android Clang 9.0.3 build ID
  `5484270 based on r353983c`, and FOTA `MTK8768_10.0` have not been matched to
  a candidate's full source history or build metadata.
* The exact HX8279 BOE-US105 LCM source and its registration/Makefile entry are
  missing. Similar HX8279 names have distinct vendor panel names and different
  initialization/power procedures; do not copy them as substitutes.

## Missing material required before a device port

1. Actual `kernel/stock.config` and `evidence/report.txt` files in this repo or
   their verified hashes/source provenance. The request's pasted configuration
   excerpts can guide inspection but are not enough for full config comparison.
2. Exact eSTAR GPL kernel release archive (or vendor git tree) corresponding to
   firmware `US105I.Q0.V9.82.YH-V09.8019`, including commit/tag, complete source,
   license notices and build scripts.
3. Stock boot image and extracted kernel/ramdisk metadata; DTB(s), DTBO image
   and exact loaded FDT. Full, verified backups are required before any later
   device validation; no write/flash action is authorized here.
4. Exact selected LCM implementation/source and compiled option; full LCM init
   table and target power/reset wiring evidence.
5. Exact device DTS/DTSI, pinctrl, PMIC regulator, touch I2C address/IRQ/reset,
   eMMC, USB, audio, Wi-Fi and firmware/blob mapping.
6. Android vendor partition/firmware inventory and modules for Wi-Fi, GPU,
   audio, sensors, camera and modem as needed for a Halium/Droidian userspace.
7. Complete exact stock config, including symbols absent from supplied excerpt,
   and the original toolchain package or an independently reproducible matching
   compiler environment.

## Next technical steps (safe, no device writes)

1. Run the pinned acquisition script, preserve its `.source-url` and
   `.source-commit` markers, and compare the candidate driver/Kconfig/DTS trees
   offline against the supplied stock config and any recovered stock DTB/DTBO.
2. Obtain the eSTAR GPL archive from the manufacturer/supplier for the exact
   firmware. Verify archive hash and kernel Makefile version before selecting a
   base. If unavailable, request source and build scripts from the supplier;
   don't manufacture a target DTS from a Lenovo DTS.
3. Extract/inspect stock boot and DTBO only from verified read-only backups;
   record hashes and image metadata, without unlock/flash/erase.
4. Only after selecting a source tree that is sufficiently close, make a clean
   4.9.190 baseline and test config/build offline. Develop panel and touch
   patches only against matched board support and verified hardware data.
5. Droidian/Halium feasibility remains conditional on a working matching kernel,
   boot/initramfs/DTB, vendor blobs, and userspace ABI/service integration. GSI
   or Treble properties alone are not proof of compatibility.

No patch has been applied to the kernel, stock config, DTS, or device. No device
commands have been run. Never flash or erase partitions during this research.
