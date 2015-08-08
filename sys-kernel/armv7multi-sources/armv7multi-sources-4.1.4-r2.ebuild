# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ETYPE="sources"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="8"
K_DEBLOB_AVAILABLE="0"
K_KDBUS_AVAILABLE="1"
#K_NOUSEPR="1"

inherit kernel-2 eutils
detect_version
detect_arch

inherit versionator
MY_PR="armv7-x${PR/r/}"
EXTRAVERSION="-${MY_PR}"
MY_P="${OKV}-${MY_PR}"

MULTI_PATCH="patch-${MY_P}.diff"
MULTI_URI="https://rcn-ee.com/deb/sid-armhf/v${MY_P}/${MULTI_PATCH}.gz"

KEYWORDS="~arm"
HOMEPAGE="https://eewiki.net/display/linuxonarm/Home"

DESCRIPTION="Full sources for ${OKV} kernel plus Wandboard, Udoo, and BeagleBone patches"
SRC_URI="
	${KERNEL_URI}
	${MULTI_URI}
	${ARCH_URI}
	imx? ( ${GENPATCHES_URI} )
	"

KEYWORDS="~arm"
IUSE="experimental imx"

K_EXTRAELOG="This is the bleeding-edge patch set on full gentoo-sources
 kernel from LinuxOnArm maintainer Robert C Nelson.  Intended mainly
 for i.MX-based boards like Wand or Udoo (use bone-sources for building
 a beaglebone kernel)."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

src_unpack() {
	# need to unpack manually due to patch reqs below
	use imx && unpack ${MULTI_PATCH}.gz

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
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
