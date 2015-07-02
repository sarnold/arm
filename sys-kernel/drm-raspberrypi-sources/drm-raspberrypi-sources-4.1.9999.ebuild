# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

ETYPE=sources
K_DEFCONFIG="bcm2835_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-2 versionator
EGIT_REPO_URI=https://github.com/anholt/linux.git
EGIT_PROJECT="rpi-drm-linux.git"
EGIT_BRANCH="vc4-kms-v3d"

DESCRIPTION="Raspberry PI kernel sources with bleeding edge VC4 DRM patches"
HOMEPAGE="https://github.com/anholt"

KEYWORDS=""

src_unpack() {
	git-2_src_unpack
	unpack_set_extraversion
}
