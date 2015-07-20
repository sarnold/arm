# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ETYPE="sources"
KPATCH_DIR="${WORKDIR}/tegra-patches/"
K_DEFCONFIG="nyan-big_steev_test_defconfig"
K_DEBLOB_AVAILABLE="0"
K_NOUSEPR="1"
K_SECURITY_UNSUPPORTED="1"
EXTRAVERSION="-${PN}/-*"

EGIT_REPO_URI=https://github.com/Gnurou/linux.git
EGIT_PROJECT="nouveau-linux.git"
EGIT_BRANCH="staging/nouveau"

inherit kernel-2
detect_version
detect_arch

inherit git-2 versionator
NV_PATCHES="tegra-patches.tar.gz"
NV_URI="mirror://gentoo/${NV_PATCHES}"
# this is taken care of in src_prep
#UNIPATCH_LIST="${DISTDIR}/${NV_PATCHES} ${UNIPATCH_LIST}"

DESCRIPTION="The latest staging version of the Tegra-nouveau Linux kernel"
HOMEPAGE="https://github.com/NVIDIA/tegra-nouveau-rootfs"

SRC_URI="${NV_URI}"

KEYWORDS="~arm"
IUSE="deblob"

K_EXTRAELOG="A copy of the latest steev config has been installed as
${K_DEFCONFIG}. If you are reading this, you know what to do..."

K_EXTRAWARN="This kernel is not supported by Gentoo due to its unstable and
experimental nature, and although it's very recent, may still have security
vulnerabilities. See gentoo-embedded on IRC if you have questions, or feel
free to ile an issue on github: https://github.com/steev/arm/issues."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

src_prepare() {
	update_config

	for p in "${KPATCH_DIR}"/*.patch* ; do
		UNIPATCH_LIST+=" ${p}"
	done

	unipatch "${UNIPATCH_LIST}"
}

update_config() {
	cp -f "${WORKDIR}"/steev_nyan-big_config \
		"${S}"/arch/arm/configs/${K_DEFCONFIG} \
		|| die "failed to install custom config!"
}

