#!/usr/bin/env bash
# Fetch pinned, read-only research references for the MID1020L source audit.
# This clones/checks out public GitHub repositories under sources/ only.
# It does not patch, build, unlock, flash, erase, or access a connected device.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_ROOT="${ROOT}/sources"
mkdir -p "${DEST_ROOT}"

fetch_pinned() {
    local name="$1" url="$2" commit="$3" dest="${DEST_ROOT}/$1"
    if [[ -e "${dest}" ]]; then
        echo "Refusing to overwrite existing path: ${dest}" >&2
        return 1
    fi
    echo "Fetching ${name} (${commit})"
    git clone --filter=blob:none --no-checkout "${url}" "${dest}"
    git -C "${dest}" checkout --detach "${commit}"
    test "$(git -C "${dest}" rev-parse HEAD)" = "${commit}"
    printf '%s\n' "${url}" > "${dest}/.source-url"
    printf '%s\n' "${commit}" > "${dest}/.source-commit"
}

# Hardware-exact family/platform reference, but kernel 4.19.191.
fetch_pinned flitsmeister-android-os-kernel \
    https://github.com/flitsmeister/android-os-kernel.git \
    ed306e55b1ff9a96980edde7998fdff792b4b04e

# Same MediaTek project and board DTS/defconfig naming, Lenovo device, 4.9.200.
fetch_pinned nt-project-lenovo-tb8505x \
    https://github.com/NT-Project/android_kernel_lenovo_tb8505x.git \
    61af5d9350b3f670a1548b7f66b7ab4181e3923e

fetch_pinned barracuda-fplus-r570e \
    https://github.com/Barracuda72/android_kernel_fplus_r570e_old.git \
    1718901c45f7d4db6ea793c6cd6cd44600c1aab9

fetch_pinned mediatek-mt6761-62-4.9 \
    https://github.com/mediatek-android-development/android_kernel_mediatek_mt6761-62-4.9.git \
    100227b164b750408d61e40e153ec10c49d48863

fetch_pinned librehu-autochips-ac8257-4.9 \
    https://github.com/LibreHU/android_kernel_autochips_ac8257_4.9.git \
    83fca99a8027cb85d70ebc3838f04859a40fd0f5

# Negative/control comparison: TALPAD PD2 is documented as MT8797, 4.19.191.
fetch_pinned talpad-talih-pd2-kernel \
    https://github.com/TALPAD-BOOM-Developers/TALIH-PD2-Kernel.git \
    f07b78c03128c71ab9a6e5da0bfaad858281390b

echo "Pinned source references fetched under ${DEST_ROOT}."
echo "Review SOURCE_AUDIT.md; no tree is automatically approved as a build base."
