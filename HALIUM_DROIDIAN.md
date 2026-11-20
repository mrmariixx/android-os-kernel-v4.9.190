# Halium and Droidian feasibility

## Status: not yet a device port

The target reports Android 10/API 29, ARM64, Treble enabled and dynamic
partitions. These facts are useful but do **not** prove Halium 9/10, libhybris,
Droidian or a GSI can boot. No eSTAR MID1020L Halium/Droidian device tree,
compatible boot image, initramfs or tested vendor integration has been
identified.

Official starting references:

- Droidian: https://droidian.org/
- Device directory: https://devices.droidian.org/
- Droidian porting documentation: https://docs.droidian.org/docs/porting/
- Droidian porting guide: https://github.com/droidian/porting-guide
- Halium distribution documentation: https://docs.halium.org/en/latest/Distribution.html

## Likely requirements to resolve

1. A verified device kernel source and exact board DTS/DTB/DTBO, including the
   eSTAR MTK vendor interfaces expected by Android 10 userspace.
2. A known-good boot image layout and kernel command line, plus initramfs
   strategy compatible with LK, AVB/vbmeta state, and dynamic partitions.
3. Read-only inventory and licensed extraction process for the Android vendor
   partition, firmware and proprietary services. Candidate services include
   GPU, Wi-Fi, Bluetooth, audio, sensors, power and graphics. Presence in
   vendor alone does not guarantee libhybris ABI compatibility.
4. Determine whether the device can run a Halium-compatible Android container
   with its Android 10 userspace or needs a different vendor adaptation path.
5. A working rootfs/init sequence, display/input, networking, suspend/resume,
   storage and recovery testing before claiming a port.

## Compatibility hypotheses, not conclusions

- Android 10/API 29 and Treble make vendor/system separation more likely, but
  do not imply that Android 10 vendor blobs work with a Halium 9 userspace.
- Halium 9 might be a possible compatibility target for some Android 10 devices;
  it is not established for this MTK BSP or this tablet.
- The current vendor MTK framebuffer/LCM and PowerVR RGX interfaces may require
  proprietary Android services and matching blobs. No mainline DRM replacement
  is justified by available evidence.
- Dynamic partitions complicate image deployment and recovery; partition names
  and fastboot product do not describe an installer or safe flashing method.

No Droidian image, installer, vendor overlay, or device configuration is
produced by this project yet. Do not attempt installation on the tablet.
