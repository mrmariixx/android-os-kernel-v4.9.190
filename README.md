# MID1020L Linux source audit

This repository is a 4.19.191 MediaTek source tree, not the eSTAR's reported
4.9.190 source. This work remains in source discovery: **no device port or
panel/touch changes have been applied** because no exact eSTAR source/DTB/DTBO
has been verified. In particular, do not infer the HX8279 panel wiring or
initialization from another HX8279-named panel.

The strongest public references found are Flitsmeisters 4.19.191 tree (exact
`tb8768p1_64_bsp` family identifiers and the US105 GSLX68X touch profile) and
the Lenovo TB8505X 4.9.200 tree (same project-name DTS/defconfig identifiers,
but another manufacturer's board). Neither is confirmed as the MID1020L's
source. See [SOURCE_AUDIT.md](SOURCE_AUDIT.md) for per-repository findings,
configuration comparison, missing material, licensing notes and safe next
steps.

`kernel/stock.config`, `evidence/report.txt`, stock boot image, DTB/DTBO and a
verified full backup were not present at the paths provided during audit. The
hardware/config details in the port request remain user-provided facts until
those evidence files are added and verified. Do not modify the stock config or
device partitions.

To acquire the pinned public candidate repositories in isolated directories
without overwriting existing paths:

```sh
bash tools/mid1020l-fetch-sources.sh
bash tools/mid1020l-audit.sh
```

The fetch script performs Git clone/checkout only. It does not patch or build
any candidate and does not run device tools. Candidate source licenses must be
reviewed and preserved before any code is redistributed. No unlock, flash,
erase, or partition modification has been attempted or authorized.
