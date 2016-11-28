# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ETYPE="sources"
K_DEFCONFIG="bb-kernel_defconfig"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="8"
K_DEBLOB_AVAILABLE="0"
K_KDBUS_AVAILABLE="1"

inherit kernel-2 eutils
detect_version
detect_arch

inherit versionator
MY_PR="bone${PR/r/}"
EXTRAVERSION="-${MY_PR}"
MY_P="${OKV}-${MY_PR}"

BONE_PATCH="patch-${MY_P}.diff"
BONE_CONFIG="defconfig"
BONE_URI="https://rcn-ee.com/deb/xenial-armhf/v${OKV}-${MY_PR}"
B_PATCH_URI="${BONE_URI}/${BONE_PATCH}.gz"
B_CONFIG_URI="${BONE_URI}/${BONE_CONFIG}"

KEYWORDS="~arm"
HOMEPAGE="https://eewiki.net/display/linuxonarm/BeagleBone+Black"

DESCRIPTION="Full sources ${KV_MAJOR}.${KV_MINOR} kernel plus BeagleBone patches"
SRC_URI="
	${KERNEL_URI}
	${ARCH_URI}
	${GENPATCHES_URI}
	${B_PATCH_URI}
	${B_CONFIG_URI} -> ${K_DEFCONFIG}"

IUSE=""

K_EXTRAELOG="This is the bleeding-edge patch set on full gentoo-sources
kernel from LinuxOnArm maintainer Robert C Nelson.  Intended mainly
for beagleboneblack.  A copy of the latest config has been installed as
${K_DEFCONFIG}.  If you are reading this, you know what to do..."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

src_prepare() {
	# We can't use unipatch or epatch here due to the git binary
	# diffs that always cause dry-run errors (even with --force).
	# That is okay since this is not intended for beaglebone.

	ebegin "Applying ${BONE_PATCH}"
		patch -p1 "${WORKDIR}"/${BONE_PATCH}
	eend $? || return

	update_config
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
