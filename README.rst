==========
Gentoo ARM
==========

Drivers and misc for Gentoo on various ARM devices, for Chromebook, Trimslice
diskless, udoo/wandboard, beagleboneblack, allwinner a-10, and rpi.  Some 
of the relevant/current graphics configs are documented below.

To get started, add the overlay to make.conf, update package.foo and USE 
flags as needed, and mask packages as needed.  The general config is:

 * ACCEPT_KEYWORDS="~arm"

 * Basic config: udev, polkit, consolekit, xattr, caps, pam (no systemd or logind)

 * X support: xwayland, opentegra, fbturbo, armsoc

 * wayland/weston: egl/gles1/gles2 (no opengl except a few cases)

 * Needs package.foo for complete install (depends on usage)

 * Kernels: rpi-sources and adafruit-rpi-sources ebuilds (the latter for PiTFT displays)

   - Trimslice: gentoo-sources (3.15.7-gentoo)

   - RaspberryPi: see above; with fbtft drivers (3.15.8-adafruit+) and without (3.12.21-raspberrypi)

   - Wandboard-quad and Udoo-quad: `RCN LinuxOnArm`_ patches on mainline (wand: 3.16.3-armv7-x4-00237-gd472049, udoo: 3.15.0-rc8-armv7-x1.2)

   - BeagleboneBlack: RCN bb_kernel patches on mainline (3.15.0-bone1)

   - Chromebook: stock Google ChromeOS 3.4.0 (custom config, installed as KERN3, USB3 rootfs)

   - Efikamx: "Latest" upstream kernel, custom config (2.6.31.14.27-efikamx) external ASIX module, SDCard rootfs

   - MK802-II 1 GB: "Latest" upstream kernel with correct device tree (3.4.75.sun4i+), custom config, SDCard rootfs

.. _RCN LinuxOnArm: http://eewiki.net/display/linuxonarm/Home

Steev's test setup:

(other) Steve's test setup:

 * Hardware: Trimslice, Wandboard quad, Chromebook, Raspberry Pi, Udoo quad, BeagleboneBlack, Efikamx Smartbook, MK802-II (A10)

  - Full X is only built for the first 4 (so far) with wayland/weston testing in progress).

 * Overlays:

  - https://github.com/sarnold/portage-overlay  (general)

  - https://github.com/sarnold/arm (pushes to steev/arm)

 * Configs: See the config directory for test configs

Config differences are minimal, mainly graphics and neon. Webkit-gtk builds with everything but jit, the cairo gles backend is enabled instead of opengl, and Trimslice uses opentegra-specific repos and mesa-9999.

You can (optionally) add this overlay with layman::

  $ wget "https://raw.github.com/steev/arm/master/configs/layman.xml" -O /etc/layman/overlays/arm_support.xml
  $ layman -f -a arm_support

