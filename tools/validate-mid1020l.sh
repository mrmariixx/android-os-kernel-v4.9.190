#!/usr/bin/env bash
# Read-only prerequisites and script syntax checks for the MID1020L project.
# No adb/fastboot/device operations are performed.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
status=0

fail() { printf 'BLOCKED: %s\n' "$*"; status=1; }
pass() { printf 'OK: %s\n' "$*"; }

if [[ -f "${ROOT}/Makefile" ]]; then
    version="$(awk -F' = ' '/^VERSION = / {v=$2} /^PATCHLEVEL = / {p=$2} /^SUBLEVEL = / {s=$2} END {print v "." p "." s}' "${ROOT}/Makefile")"
    if [[ "$version" == "4.9.190" ]]; then pass "root source Makefile reports ${version}"; else fail "root source is ${version}; device is reported 4.9.190"; fi
else
    fail "root Makefile missing"
fi

for f in kernel/stock.config evidence/report.txt evidence/config.gz; do
    if [[ -s "${ROOT}/${f}" ]]; then pass "${f} exists and is non-empty"; else fail "${f} absent or empty"; fi
done

for f in tools/mid1020l-audit.sh tools/mid1020l-fetch-sources.sh tools/validate-mid1020l.sh tools/build-kernel.sh; do
    if [[ -f "${ROOT}/${f}" ]] && bash -n "${ROOT}/${f}"; then pass "bash syntax ${f}"; else fail "missing or invalid shell script ${f}"; fi
done

if [[ -f "${ROOT}/kernel/stock.config" ]]; then
    for symbol in CONFIG_ARM64 CONFIG_MTK_LCM CONFIG_MTK_FB CONFIG_TOUCHSCREEN_MTK_GSLX68X CONFIG_MMC_MTK_PRO CONFIG_MTK_EMMC_SUPPORT; do
        if grep -Eq "^${symbol}=y$" "${ROOT}/kernel/stock.config"; then pass "stock config enables ${symbol}"; else fail "stock config missing expected enabled ${symbol}"; fi
    done
fi

printf '\n'
if (( status != 0 )); then
    echo "Validation incomplete/blocked; do not claim a kernel port or device boot."
    exit 1
fi
echo "Static prerequisite checks passed. This does not establish hardware compatibility or bootability."
