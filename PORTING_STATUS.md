# MID1020L porting status

**Status: research and build scaffolding only; no device port or bootable image.**

## Completed from repository/code research

- Confirmed the repository's own kernel is Linux 4.19.191, not the tablet's reported 4.9.190.
- Located the exact `US105_MJK_1298FPC_WUXGANL_101` GSLX68X profile and `tb8768p1_64_bsp` platform/DTS references in Flitsmeister's 4.19.191 tree.
- Located a Lenovo `tb8768p1_64_bsp` DTS/defconfig in a 4.9.200 tree. This is a comparator, not an eSTAR board source.
- Documented why neither candidate currently qualifies as a sufficiently verified port base.
- Added safe local audit, fetch, validation and guarded build scripts. They do not operate on a connected device.

## Not done / blocked

- No verified exact eSTAR GPL kernel archive or matching 4.9.190 source has been established.
- No eSTAR DTB/DTBO or device DTS/pin/regulator/boot metadata is present in this GitHub repo. `kernel/stock.config` and `evidence/report.txt` were not found in the repository paths checked; user-provided details are preserved in docs as supplied facts.
- No exact US105 HX8279 BOE LCM implementation has been found.
- No touchscreen code was copied or backported; driver support and framework API dependencies remain to be compared against an exact 4.9 tree.
- Wi-Fi chip/driver/firmware, audio route, vendor modules/blobs, GPU userspace, and Halium userspace integration have not been verified.
- No kernel build was run. No device boot or hardware test has occurred.
- No boot/recovery/DTBO/vbmeta images or verified full restore backup exists, and the bootloader is reported locked.

## Current feasibility

A compile-only test can be attempted only after an operator supplies a source directory whose top-level Makefile says exactly 4.9.190 and a copy of the stock config. `tools/build-kernel.sh` enforces these conditions and builds out-of-tree; it does not package or flash an image. Compilation would not prove bootability.

Droidian remains a research target, not a prepared install. Treble/Android 10 alone does not demonstrate Halium compatibility. A working kernel/DTB/boot path, Android 10 vendor components, userspace compatibility, initramfs and recovery route are still prerequisites.

## Safety

No unlock, fastboot, partition write, erase, format, boot-image repack, or firmware modification has been performed. Keep the tablet on stock Android until exact sources, complete read-only backups, and a verified recovery route are available.

## Next safe milestone

Obtain the eSTAR GPL source matching firmware `US105I.Q0.V9.82.YH-V09.8019`, the exact selected LCM source and board DTS/DTBO plus boot metadata. Verify hashes and versions, then run `tools/validate-mid1020l.sh`. Only then consider a compile-only build with `tools/build-kernel.sh`.
