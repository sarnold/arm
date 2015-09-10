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

 * X support: xwayland, opentegra, fbturbo, armsoc, rpi (still in testing)

 * wayland/weston: egl/gles1/gles2, -opengl -glx (except a few odd packages with opengl flag)

 * Needs package.foo configs for complete install (depends on usage)

 * Kernels sources:

   - Trimslice: gentoo-sources latest

   - RaspberryPi: fbtft drivers now in Adafruit staging

      + raspberrypi-sources
      + adafruit-raspberrypi-sources
      + drm-raspberrypi-sources (provisional vc4 drm support)

   - Wandboard-quad and Udoo-quad: `RCN LinuxOnArm`_ patches on mainline

      + latest 4.1.y mainline branch

   - BeagleboneBlack: RCN bb_kernel patches on mainline

      + bone-sources updated to 4.1.0-bone9
      + see `RCN LinuxOnArm`_ for latest updates

   - Chromebook: next dev branch beyond stock Google ChromeOS (custom config, installed as KERN3, USB3 rootfs or SDCard)

      + Samsung Snow - 3.8.11 chromeos-sources
      + Tegra K1 - 3.10.18 chromeos-sources

   - Jetson K1 - 3.19.0-rc6 linux-jetson

   - Efikamx: "Latest" upstream kernel, custom config (2.6.31.14.27-efikamx) external ASIX module, SDCard rootfs

   - MK802-II 1 GB: "Latest" upstream kernel with correct device tree (3.4.75.sun4i+), custom config, SDCard rootfs

.. _RCN LinuxOnArm: http://eewiki.net/display/linuxonarm/Home

Steev's test setup:

(other) Steve's test setup:

 * Hardware: Jetson, Trimslice, Wandboard quad, Chromebooks (snow and K1), Raspberry Pi B/B+/B2, Udoo quad, Cubox quad, BeagleboneBlack

  - Full X is only built for all of them (so far) with wayland/weston testing in progress)

    + gles/egl, no opengl/glx, cairo/clutter/cogl, +qt5/-qt4, +gtk3/-gtk

 * Overlays:

  - https://github.com/sarnold/portage-overlay  (general)

  - https://github.com/sarnold/arm (pushes to gentoo/arm)

 * Recommended CPU flags

  - armv7 defaults: -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard

   + add neon to USE flags if processor supports it, ebuilds that use neon should take care of flags

  - alternately you can set fpu to one of the neon-vfp flags

   + Example flags for Tegra K1:
   + -march=armv7-a -mtune=cortex-a15 -mfpu=neon-vfpv4 -mfp16-format=ieee

 * Configs: See the config directory in arm overlay for test configs

Config differences are minimal, mainly graphics and neon. Webkit-gtk builds with everything but jit, the cairo gles backend is enabled instead of opengl, and Trimslice uses opentegra-specific repos and mesa-9999.

You can (optionally) add this overlay with layman::

  $ layman -f -a arm_support -o https://raw.github.com/gentoo/arm/master/configs/layman.xml
