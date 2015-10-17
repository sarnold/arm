# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="2"
K_DEBLOB_AVAILABLE="0"
K_KDBUS_AVAILABLE="1"

K_DEFCONFIG="nyan-big_steev_test_defconfig"
K_NOUSEPR="1"
EXTRAVERSION="-${PN}/-*"

EGIT_REPO_URI=https://github.com/Gnurou/linux.git
EGIT_PROJECT="nouveau-linux.git"
EGIT_BRANCH="staging/nouveau"

inherit kernel-2
detect_version
detect_arch

inherit git-2 versionator
NV_PV="20150723-r1"
NV_PATCHES="tegra-patches-${NV_PV}.tar.gz"
NV_URI="mirror://gentoo/${NV_PATCHES}"

DESCRIPTION="The latest staging version of the Tegra-nouveau Linux kernel"
HOMEPAGE="https://github.com/NVIDIA/tegra-nouveau-rootfs"

SRC_URI="${NV_URI} ${GENPATCHES_URI} ${ARCH_URI}"

UNIPATCH_LIST="${NV_URI} ${GENPATCHES_URI} ${ARCH_URI}"
#UNIPATCH_STRICTORDER="1"

KEYWORDS="~arm"
IUSE="experimental firmware"

K_EXTRAELOG="This kernel is still unstable and experimental but is now
fully patched up to genpatches base (so is essentially gentoo-sources
for Tegra with nouveau).  A copy of the latest steev config has been
installed as ${K_DEFCONFIG}. If you are reading this, you know what to do..."

UNIPATCH_EXCLUDE="
	drm-tegra-dpaux-Fix-transfers-larger-than-4-bytes.patch"

RDEPEND="firmware? ( >=sys-kernel/linux-firmware-99999999 )"
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

src_prepare() {
	unipatch "${UNIPATCH_LIST}"

	update_config
}

update_config() {
	cp -f "${WORKDIR}"/steev_nyan-big_config \
		"${S}"/arch/arm/configs/${K_DEFCONFIG} \
		|| die "failed to install custom config!"

	cd "${S}"
	git config user.email "arm@gentoo.org"
	git config user.name "Portage git-2"
	git add .
	git commit -n -m"removing -dirty flag"
}

