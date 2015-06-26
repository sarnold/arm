==========
Gentoo ARM
==========

Config differences are minimal, mainly graphics and neon. Webkit-gtk builds with everything but jit, the cairo gles backend is enabled instead of opengl, and Trimslice uses opentegra-specific repos and mesa-9999.

    * bbb - settings for the BeagleBone Black

    * chromebook - settings for Exynos based Chromebooks

    * imx6 - settings for i.MX6 based boards

    * K1-chromebook - settings for the Acer Tegra Chromebook

    * rpi - settings for the RaspberryPi

    * trimslice - settings for the Trimslice


    kernel-check-config.sh -
      Script based on the docker script "check-config.sh" for checking that
      various kernel config options are enabled.  Run this against your own
      kernel for your device via:

      CONFIG=/path/to/kernel.config ./kernel-check-config.sh
