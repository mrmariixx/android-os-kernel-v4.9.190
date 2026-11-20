#!/usr/bin/env bash
# Compile-only kernel build gate. Never packages or writes to a device.
set -euo pipefail

: "${KERNEL_SRC:?Set KERNEL_SRC to a verified exact Linux 4.9.190 source tree}"
: "${STOCK_CONFIG:?Set STOCK_CONFIG to a preserved copy of the original stock config}"
KERNEL_SRC="$(cd "$KERNEL_SRC" && pwd)"
STOCK_CONFIG="$(cd "$(dirname "$STOCK_CONFIG")" && pwd)/$(basename "$STOCK_CONFIG")"
OUT_DIR="${OUT_DIR:-$PWD/output/mid1020l-build}"
CLANG_BIN="${CLANG_BIN:-}"
CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-android-}"
JOBS="${JOBS:-1}"

[[ -f "$KERNEL_SRC/Makefile" ]] || { echo "Missing source Makefile: $KERNEL_SRC" >&2; exit 1; }
[[ -f "$STOCK_CONFIG" ]] || { echo "Missing stock config: $STOCK_CONFIG" >&2; exit 1; }
[[ "$OUT_DIR" != "$KERNEL_SRC" && "$OUT_DIR" != "$KERNEL_SRC/"* ]] || {
    echo "OUT_DIR must be outside kernel source tree" >&2; exit 1;
}

version="$(awk -F' = ' '/^VERSION = / {v=$2} /^PATCHLEVEL = / {p=$2} /^SUBLEVEL = / {s=$2} END {print v "." p "." s}' "$KERNEL_SRC/Makefile")"
[[ "$version" == "4.9.190" ]] || {
    echo "Refusing build: source is $version, expected exact 4.9.190" >&2; exit 1;
}
grep -Eq '^CONFIG_ARM64=y$' "$STOCK_CONFIG" || { echo "Stock config lacks CONFIG_ARM64=y" >&2; exit 1; }
for symbol in CONFIG_MTK_LCM CONFIG_MTK_FB CONFIG_TOUCHSCREEN_MTK_GSLX68X CONFIG_MMC_MTK_PRO CONFIG_MTK_EMMC_SUPPORT; do
    grep -Eq "^${symbol}=y$" "$STOCK_CONFIG" || { echo "Stock config lacks ${symbol}=y" >&2; exit 1; }
done

mkdir -p "$OUT_DIR"
cp --no-clobber "$STOCK_CONFIG" "$OUT_DIR/.config"
if [[ -n "$CLANG_BIN" ]]; then
    [[ -x "$CLANG_BIN/clang" ]] || { echo "clang not executable under CLANG_BIN" >&2; exit 1; }
    export PATH="$CLANG_BIN:$PATH"
fi

MAKE_ARGS=(ARCH=arm64 O="$OUT_DIR" CROSS_COMPILE="$CROSS_COMPILE")
if command -v clang >/dev/null 2>&1; then
    MAKE_ARGS+=(CC=clang)
fi

# olddefconfig changes only the output copy at O=; original stock config remains untouched.
make -C "$KERNEL_SRC" "${MAKE_ARGS[@]}" olddefconfig
for symbol in CONFIG_ARM64 CONFIG_MTK_LCM CONFIG_MTK_FB CONFIG_TOUCHSCREEN_MTK_GSLX68X CONFIG_MMC_MTK_PRO CONFIG_MTK_EMMC_SUPPORT; do
    grep -Eq "^${symbol}=y$" "$OUT_DIR/.config" || {
        echo "Resolved Kconfig disabled/lost ${symbol}; refusing compilation" >&2; exit 1;
    }
done

# Build an image only. No modules are installed and no boot image is packaged.
make -C "$KERNEL_SRC" "${MAKE_ARGS[@]}" -j"$JOBS" Image
printf 'Compile output (not a bootability claim): %s\n' "$OUT_DIR/arch/arm64/boot/Image"
sha256sum "$OUT_DIR/arch/arm64/boot/Image"
