# Recovery and device safety

## Current device state

The tablet's LK bootloader is reported locked, secure boot is enabled, and no
verified full firmware/boot/DTB/DTBO backup is available. The project does not
have a proven unlock or restore route. Accordingly, no installation or boot
image testing is safe at this point.

## Prohibited actions in this project

Do not issue `fastboot flash`, `fastboot erase`, `fastboot format`, any
bootloader unlock command, or commands that modify Android partitions. Do not
change vbmeta, boot, recovery, dtbo, super or userdata. Do not treat
`ro.oem_unlock_supported=1` as proof that an unlock is possible.

## Before any future hardware validation

This is a checklist, not permission to write partitions:

1. Obtain the exact official full firmware package for
   `US105I.Q0.V9.82.YH-V09.8019`; record source, version and cryptographic
   hashes, and confirm the package can restore this exact product.
2. Acquire verified read-only copies of boot, recovery, dtbo, vbmeta and other
   required firmware partitions using an authorized, documented method. Save
   off-device, hash each image and verify restoration instructions independently.
3. Record boot image header/version, kernel/ramdisk boundaries, cmdline, loaded
   DTB and overlays, partition sizes/layout and AVB chain metadata.
4. Establish a tested recovery path that does not depend on booting the
   experimental kernel. If bootloader lock or AVB prevents recovery, stop.
5. Only then review a separately authorized test plan. No flashing is covered
   by this repository task.

The audit/build scripts are host-side and read-only with respect to the device.
