# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

ETYPE="sources"
K_DEFCONFIG="espressobin_defconfig"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="14"
K_DEBLOB_AVAILABLE="0"
K_KDBUS_AVAILABLE="1"
H_SUPPORTEDARCH="arm64"

inherit kernel-2 eutils
detect_version
detect_arch

inherit versionator
MY_PR="armv8-x${PR/r/}"
EXTRAVERSION="-${MY_PR}"
MY_P="${OKV}-${MY_PR}"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
HOMEPAGE="https://wiki.gentoo.org/wiki/ESPRESSOBin"

DESCRIPTION="Full sources for ${OKV} kernel plus gentoo and various ARM64 device patches"
SRC_URI="
	${KERNEL_URI}
	${ARCH_URI}
	${GENPATCHES_URI}"

IUSE="mvebu64"

K_EXTRAELOG="This is the bleeding-edge patch set on full gentoo-sources
kernel with patches for Marvell espressobin and a few others, and intended
mainly for arm64 switch-ish boards, although it can be used on any arm64
host.  A copy of the latest mvebu64 config has been installed as
${K_DEFCONFIG}.  If you are reading this, you know what to do..."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

PATCHES=( "${FILESDIR}/4.13/" )

src_prepare() {
	handle_genpatches
	use mvebu64 && eapply "${PATCHES[@]}"
	update_config
	kernel-2_src_prepare
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
	cp -f "${FILESDIR}"/4.13/${K_DEFCONFIG} "${S}"/arch/arm64/configs/ \
		|| die "failed to install ${K_DEFCONFIG}!"
}

