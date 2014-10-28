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

 * Kernels: rpi-sources and adafruit-rpi-sources (the latter for PiTFT displays)

Steev's test setup:

(other) Steve's test setup:

 * Hardware: Trimslice, Wandboard quad, Chromebook, Raspberry Pi, Udoo quad, BeagleboneBlack, Efikamx Smartbook, MK802-II (A10)

  - Full X is only built for the first 4 (so far) with wayland/weston testing in progress).

 * Overlays:

  - https://github.com/sarnold/portage-overlay  (general)

  - https://github.com/sarnold/arm (pushes to steev/arm)

 * Configs: See the config directory for test configs

