arm
===

Drivers and misc for Gentoo on various ARM devices, for Chromebook, Trimslice
diskless, udoo/wandboard, beagleboneblack, allwinner a-10, and rpi.  Some 
of the relevant/current graphics configs are documented below.

To get started, add the overlay to make.conf and update package.* and USE 
flags as needed, and mask packages as needed.  The general recommended 
config is:

* ACCEPT_KEYWORDS="~arm"
* udev, polkit, consolekit, xattr, caps, pam (no systemd or logind)

* X support
  * xf86-video-opentegra (Trimslice, tegra20/tegra30 machines)
    * webkit-gtk-2.4.3 - use flags: -opengl -geoloc gles2 -gstreamer -introspection -jit -webgl webkit1
    * midori-0.5.8-r1 - use flags: granite -jit webkit2 -deprecated -introspection
    * mesa-10.2.4 - use flags: classic egl gallium gles1 gles2 llvm nptl pic xa xvmc -bindist
  * udev (small arm boards)
    * sys-fs/udev-212-r1 - use flags: acl firmware-loader gudev introspection kmod pam polkit xattr
    * virtual/udev-208-r2 - use flags: gudev hwdb


