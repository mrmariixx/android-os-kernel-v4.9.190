# Hardware compatibility matrix — eSTAR MID1020L

Evidence labels:

- **Supplied**: reported in the device information provided for this project; original binaries/config files are not currently present in this GitHub tree.
- **Repository evidence**: found in a named public reference tree; does not by itself prove it matches this tablet.
- **Unknown**: must be acquired or measured; do not infer it from another device.

| Subsystem | Supplied target evidence | Repository evidence | Status / missing proof |
|---|---|---|---|
| SoC / CPU | MT6765 platform, MT8768 hardware property, ARM64 Cortex-A53 octa-core | Flitsmeister 4.19.191 and Lenovo 4.9.200 identify platform `mt6765` and project `tb8768p1_64_bsp` | Platform family correlation. Exact eSTAR BSP source, memory map and board integration unverified. |
| Kernel | Linux 4.9.190, Android Clang 9.0.3 (`5484270 based on r353983c`) | Project repository is 4.19.191; Lenovo candidate 4.9.200; other MTK reference trees 4.9.117/4.9.119 | Exact 4.9.190 tree and matching toolchain package absent. |
| Display / panel | 1920x1200 60 Hz; LCM name `us105_fx_hx8279_boe_wuxga_ips_101`; `CONFIG_MTK_LCM=y`, `CONFIG_MTK_FB=y`; LCM DT support unset | HX8279 LCM files exist for other US717/US720/US828 vendor variants in Flitsmeister 4.19.191 | Exact US105 FX/HX8279/BOE LCM source and registration not found. Timings, DSI settings, GPIOs, regulator and reset sequence unknown. Do not copy similar panel code. |
| Display architecture | MTK framebuffer/LCM in supplied stock configuration; DRM symbols also enabled | Candidate BSPs use vendor MTK LCM/FB implementation; this is not evidence that standard DRM/KMS drives the panel | Preserve vendor interfaces until the exact source shows the roles of the configured components. |
| Touchscreen | `US105_MJK_1298FPC_WUXGANL_101`; GSLX68X; `CONFIG_TOUCHSCREEN_MTK_GSLX68X=y` | Exact named profile, profile list selection and `tb8768p1_64_bsp`-family source are present in Flitsmeister tree at 4.19.191 | Strong firmware/profile match. Driver API/BSP dependencies at 4.9.190, I2C address, IRQ polarity, reset, supply and DT wiring still need target-source evidence. No backport made. |
| eMMC | eMMC; `CONFIG_MMC_MTK_PRO=y`, `CONFIG_MTK_EMMC_SUPPORT=y` | Related board DTS/config references use MTK MSDC/eMMC | Exact controller node, pins, voltage, partition geometry and boot metadata absent. |
| PMIC / charging | MT6357 new architecture/common, MT6357 PMIC, charger enabled | Candidate trees expose MT6357 family support | Exact PMIC DTS, rails, board wiring and charger/thermal settings unverified. |
| Wi-Fi / Bluetooth | Android modules observed: `wlan_drv_gen4m`, `wmt_chrdev_wifi`, `wmt_drv` | Generic defconfig search excerpts do not identify tablet WLAN chip or its full driver/firmware dependency | Chipset, kernel module source, firmware, regulatory configuration, Android vendor service and Bluetooth combo stack unknown. |
| Audio | ALSA devices observed; MT6357 reported | Candidate DTS contains MTK audio pin states for other products | Codec/audio route, amp, GPIOs, clocks, firmware and Android audio HAL dependence unknown. |
| GPU | PowerVR Rogue GE8320; MTK GPU config reports `rgx doma m1.9ED4940716` | Candidate trees contain MediaTek GPU support, not evidence that the proprietary GE8320 driver/userspace matches | Exact kernel GPU driver, firmware, userspace libraries and ABI unknown; acceleration unverified. |
| USB | USB gadget enabled in supplied config; XHCI/DWC3 unset | MTK USB implementation exists in candidate BSPs | Exact controller mode, cable role, gadget composition, charging and host support require target DTS/driver. |
| Sensors/camera | Not fully specified | Candidate sources contain many unrelated module choices | Do not assume sensor/camera configurations based on other board variants; exact inventory and blobs missing. |
| Boot / DTB / DTBO | LK bootloader, locked; boot p30, recovery p2, dtbo p32, dynamic partitions; no image dump | Related `tb8768p1_64_bsp` DT sources exist for other products | Exact loaded FDT/DTBO, boot header, cmdline, ramdisk and verified backup absent. Device boot cannot be assessed. |
| Halium / Droidian | Android 10, API 29, Treble true, dynamic partitions true, ARM64 | No device-specific Halium/Droidian port identified | Treble is insufficient. Need compatible boot/initramfs, kernel interfaces, vendor blobs/services, libhybris/Android container strategy and recovery. |

## Practical conclusion

The shared board/project string plus exact touch-profile data makes the public
4.19 tree valuable for forensic comparison. The Lenovo 4.9.200 tree may help
compare MTK 4.9 BSP APIs and common board definitions. Neither may be treated
as the eSTAR MID1020L board implementation without exact source/DT/firmware
matching. The exact panel implementation, eSTAR DTB/DTBO and stock boot image
remain hard blockers.
