# Kernel source, configuration and compile-only build

## Current source state

This repository's kernel tree is Linux 4.19.191. The device is reported to run
4.9.190. Do not compile the repository tree as if it were the MID1020L kernel.
No device-specific 4.9.190 source has been verified or acquired into `sources/`.

## Build gate

`tools/build-kernel.sh` requires an externally supplied `KERNEL_SRC` whose
Makefile reports exactly Linux 4.9.190, plus `STOCK_CONFIG` pointing at a copy
of the tablet's original config. It copies that config into an out-of-tree
output folder, checks architecture and critical device options, runs
`olddefconfig`, checks critical options again, and compiles the kernel image
with `ARCH=arm64`. It never edits the supplied config and never packages,
installs, flashes or writes to a device.

Example, only after obtaining and verifying the exact source:

```sh
KERNEL_SRC=/path/to/verified/linux-4.9.190 \
STOCK_CONFIG=/path/to/verified/stock.config \
OUT_DIR="$PWD/output/mid1020l-build" \
CLANG_BIN=/path/to/Android-llvm-9.0.3/bin \
CROSS_COMPILE=aarch64-linux-android- \
JOBS="$(nproc)" \
bash tools/build-kernel.sh
```

This produces a compile artifact only. It does not imply the bootloader will
accept it or that a device can boot it. Toolchain version, linker, binutils,
`ARCH_MTK_PROJECT`, platform Makefile variables and vendor build wrappers must
be checked against the exact source release before treating the build as a
reproduction of the stock build.

## Configuration discipline

- Preserve the original config; do not use it as an output file.
- Keep device-specific options as a documented delta after exact Kconfig
  dependencies and target-source symbols are inspected.
- Do not turn on standard DRM panel/KMS as a replacement for MTK LCM/FB based
  only on generic Linux guidance.
- Require GSLX68X and MTK LCM/FB config symbols to remain enabled in initial
  build configuration; an unavailable symbol is a source mismatch, not a reason
  to silently drop the subsystem.
- Stock config facts supplied in the task do not include the complete config
  file in this GitHub repository. The build remains blocked until its verified
  copy is supplied locally.

## Validation

Run:

```sh
bash tools/validate-mid1020l.sh
```

The validator is read-only and reports missing evidence/source as blocked. It
never claims a successful device build unless the guarded build script produced
an image from an explicitly supplied 4.9.190 tree.
