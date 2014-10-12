# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

ETYPE=sources
K_DEFCONFIG="adafruit_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-2 versionator
EGIT_REPO_URI=https://github.com/adafruit/adafruit-raspberrypi-linux.git
EGIT_HAS_SUBMODULES="1"
EGIT_PROJECT="adafruit-raspberrypi-linux.git"
EGIT_BRANCH="rpi-$(get_version_component_range 1-2).y"

DESCRIPTION="Raspberry PI kernel sources with Adafruit patches"
HOMEPAGE="https://github.com/adafruit"

KEYWORDS=""

K_EXTRAEINFO="For Adafruit hardware, start your kernel with adafruit_defconfig."

src_unpack() {
	git-2_src_unpack
	unpack_set_extraversion
}

src_prepare() {
	if [[ -e "{$}"/drivers/video/fbtft/Kconfig ]] ; then
		continue
	else
		git submodule init
		git submodule sync
		git submodule update
	fi

	git config user.email "portage@gentoo.org"
	git config user.name "Portage git-2"
	git commit -a -n -m"removing -dirty flag"
}
