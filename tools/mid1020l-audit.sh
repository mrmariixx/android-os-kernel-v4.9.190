#!/usr/bin/env bash
# Safe, read-only repository audit. This script never runs fastboot or adb,
# never accesses the device, and never modifies a stock config.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

printf 'Project branch: '
git -C "${ROOT}" branch --show-current 2>/dev/null || echo '(not a git checkout)'
printf 'Project HEAD: '
git -C "${ROOT}" rev-parse HEAD 2>/dev/null || echo '(not a git checkout)'
printf 'Kernel Makefile version: '
sed -n 's/^VERSION = /\1./p; s/^PATCHLEVEL = /\1./p; s/^SUBLEVEL = /\1/p' "${ROOT}/Makefile" | tr -d '\n'
printf '\n'

for f in kernel/stock.config evidence/config.gz evidence/report.txt; do
    if [[ -f "${ROOT}/${f}" ]]; then
        printf 'PRESENT %s\n' "$f"
    else
        printf 'MISSING %s\n' "$f"
    fi
done

for d in "${ROOT}"/sources/*; do
    [[ -d "$d/.git" ]] || continue
    printf '\n[%s]\n' "$(basename "$d")"
    printf 'url: '; cat "$d/.source-url" 2>/dev/null || git -C "$d" remote get-url origin
    printf 'commit: '; git -C "$d" rev-parse HEAD
    if [[ -f "$d/Makefile" ]]; then
        awk '/^(VERSION|PATCHLEVEL|SUBLEVEL) = / {printf "%s ", $3}' "$d/Makefile"
        printf '\n'
        grep -E '^(VERSION|PATCHLEVEL|SUBLEVEL) = ' "$d/Makefile" | paste -sd ' ' -
    fi
    grep -RIl --exclude-dir=.git -E \
        'US105_MJK_1298FPC_WUXGANL_101|us105_fx_hx8279_boe_wuxga_ips_101|tb8768p1_64_bsp|HX8279|GSLX68X' \
        "$d/arch" "$d/drivers" 2>/dev/null | sed "s#^${d}/##" | head -80 || true
done
