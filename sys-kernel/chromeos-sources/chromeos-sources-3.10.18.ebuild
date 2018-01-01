# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

ETYPE="sources"
K_NOUSENAME="1"
#K_NOSETEXTRAVERSION="yes"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

K_DEFCONFIG="nyan-big_defconfig"
K_NOUSEPR="1"
OKV="${PV}"
MY_P=linux-chromeos-${PV}
EXTRAVERSION="-${PN}/-*"

inherit kernel-2 versionator
NV_PV="20171229"
NV_PATCHES="tegra-patches-${NV_PV}.tar.gz"
NV_URI="mirror://gentoo/${NV_PATCHES}"
CONF_URI="https://raw.githubusercontent.com/offensive-security/kali-arm-build-scripts/master/kernel-configs/chromebook-3.10.config"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://chromium.googlesource.com/chromiumos/third_party/kernel.git"
	EGIT_BRANCH="chromeos-3.10"
	EGIT_PROJECT="chromeos-linux.git"
	SRC_URI="${CONF_URI}"
	inherit git-2
	KEYWORDS=""
else
	GIT_COMMIT="3a080eaf27b2094ae104f392b4cefbbe9382b8ee"
	GIT_URI="https://chromium.googlesource.com/chromiumos/third_party/kernel/+archive/${GIT_COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
	SRC_URI="${GIT_URI} ${NV_URI} ${CONF_URI}"
	#KERNEL_URI="${SRC_URI}"
	KEYWORDS="~arm"
fi

UNIPATCH_LIST="${NV_URI}"

DESCRIPTION="Linux kernel source for the Tegra K1 Chromebook"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.10"

IUSE="firmware"

K_EXTRAELOG="This is the google-y kernel for Tegra K1 chromebooks plus some
Arch Linux patches to make a little more modern. A copy of the latest kali
config has been installed as ${K_DEFCONFIG}. To be google-y compliant with
current firmware you also need the packages listed below."

RDEPEND="firmware? ( >=sys-kernel/linux-firmware-99999999 )"
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	detect_version
	detect_arch

	if [[ ${PV} == *9999* ]] ; then
		git-2_src_unpack
	else
		cd "${WORKDIR}"
		mkdir -p "${WORKDIR}"/${MY_P}
		pushd "${WORKDIR}"/${MY_P} > /dev/null
			unpack ${P}.tar.gz
		popd > /dev/null
		unpack "${NV_PATCHES}"
	fi
}

src_prepare() {
	eapply "${WORKDIR}"/patches
	update_config
	unpack_fix_install_path

	default
}

pkg_postinst() {
	einfo "if you want to get the default kernel config just run:"
	einfo "./chromeos/scripts/prepareconfig chromeos-tegra"
}

update_config() {
	cp -f "${DISTDIR}"/chromebook-3.10.config \
		"${S}"/arch/arm/configs/${K_DEFCONFIG} \
		|| die "failed to install custom config!"

	cp -f "${FILESDIR}"/kernel-nyan.its \
		"${S}"/arch/arm/boot/ \
		|| die "failed to install kernel-nyan.its!"

	if [[ ${PV} == *9999* ]] ; then
		cd "${S}"
		git config user.email "arm@gentoo.org"
		git config user.name "Portage git-2"
		git add .
		git commit -n -m"removing -dirty flag"
	fi
}
