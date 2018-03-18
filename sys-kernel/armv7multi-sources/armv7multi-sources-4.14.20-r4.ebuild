# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="sources"
K_DEFCONFIG="gentoo-armv7-${PV}_defconfig"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="25"
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
HOMEPAGE="https://wiki.gentoo.org/wiki/Udoo"

DESCRIPTION="Full sources for ${OKV} kernel plus gentoo and various ARM/iMX device patches"
SRC_URI="
	${KERNEL_URI}
	${ARCH_URI}
	${GENPATCHES_URI}
	${M_PATCH_URI}
	${M_CONFIG_URI} -> ${K_DEFCONFIG}"

IUSE="experimental"

K_EXTRAELOG="This is the bleeding-edge mainline ARM patch set on full
gentoo-sources kernel from LinuxOnArm maintainer Robert C Nelson.
Intended mainly for TI, Allwinner, and NXP boards like Wand or Udoo,
although it should work on other ARM boards.  A copy of the latest
config has been installed as ${K_DEFCONFIG}.
If you are reading this, you know what to do..."

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-vcs/git-1.8.2.1"

src_unpack() {
	# need to unpack manually abd depend on git due to patch reqs below
	unpack ${MULTI_PATCH}.xz

	kernel-2_src_unpack

	cp "${DISTDIR}"/"${K_DEFCONFIG}" "${S}"/arch/arm/configs/ || die "copy defconfig failed!"
}

src_prepare() {
	# We can't use unipatch or epatch here due to the git binary
	# diffs that always cause dry-run errors (even with --force).
	# That is okay since this is not intended for beaglebone.

	ebegin "Applying ARMv7 ${MULTI_PATCH}"
		git apply -p1 < "${WORKDIR}"/${MULTI_PATCH} || die "multipatch failed!"
	eend $? || return

	# remove beaglebone firmware
#	sed -i '/CONFIG_EXTRA_FIRMWARE/s/".*"/""/' \
#		"${S}"/arch/arm/configs/"${K_DEFCONFIG}" || die "sed1 defconfig failed!"
	# remove unsupported compression, make VPU driver a module
	sed -i -e 's/CONFIG_VIDEO_CODA=y/CONFIG_VIDEO_CODA=m/' \
		-e 's/_COMPRESS_XZ/_COMPRESS_GZIP/' \
		"${S}"/arch/arm/configs/"${K_DEFCONFIG}" || die "sed defconfig failed!"

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

