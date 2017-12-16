# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

ETYPE="sources"
K_DEFCONFIG="gentoo-armv7multi_defconfig"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="15"
K_DEBLOB_AVAILABLE="0"
K_KDBUS_AVAILABLE="1"

inherit kernel-2 eutils
detect_version
detect_arch

inherit versionator
MY_PR="armv7-x${PR/r/}"
EXTRAVERSION="-${MY_PR}"
MY_P="${OKV}-${MY_PR}"

MULTI_PATCH="patch-${MY_P}.diff"
MULTI_CONFIG="defconfig"
MULTI_URI="https://rcn-ee.com/deb/xenial-armhf/v${MY_P}"
M_PATCH_URI="${MULTI_URI}/${MULTI_PATCH}.xz"
M_CONFIG_URI="${MULTI_URI}/${MULTI_CONFIG}"

KEYWORDS="~arm"
HOMEPAGE="https://eewiki.net/display/linuxonarm/Udoo"

DESCRIPTION="Full sources for ${OKV} kernel plus gentoo and various ARM/iMX device patches"
SRC_URI="
	${KERNEL_URI}
	${ARCH_URI}
	${GENPATCHES_URI}
	imx? ( ${M_PATCH_URI}
		${M_CONFIG_URI} -> ${K_DEFCONFIG} )"

IUSE="+imx"

K_EXTRAELOG="This is the bleeding-edge patch set on full gentoo-sources
kernel from LinuxOnArm maintainer Robert C Nelson.  Intended mainly
for i.MX-based boards like Wand or Udoo (use bone-sources for building
a beaglebone kernel).  A copy of the latest config has been installed as
${K_DEFCONFIG}.  If you are reading this, you know what to do..."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

src_unpack() {
	# need to unpack manually due to patch reqs below
	use imx && unpack ${MULTI_PATCH}.xz

	kernel-2_src_unpack
}

src_prepare() {
	# We can't use unipatch or epatch here due to the git binary
	# diffs that always cause dry-run errors (even with --force).
	# That is okay since this is not intended for beaglebone.

	if use imx ; then
		ebegin "Applying ${MULTI_PATCH}"
			patch -p1 "${WORKDIR}"/${MULTI_PATCH}
		eend $? || return
	fi

	use imx && update_config

	default
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}

update_config() {
	cp -f "${DISTDIR}"/${K_DEFCONFIG} "${S}"/arch/arm/configs/ \
		|| die "failed to install ${K_DEFCONFIG}!"
}

