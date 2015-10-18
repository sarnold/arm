# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

XORG_DRI="always"
XORG_EAUTORECONF="yes"
XORG_CONFIGURE_OPTIONS="--with-drmmode=exynos --disable-selective-werror"

inherit autotools xorg-2 flag-o-matic

MY_PR="1endless9"
MY_PV="v${PV}-${MY_PR}"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/mdrjr/xf86-video-armsoc/archive/v${PV}-${MY_PR}.tar.gz -> ${P}-${PR}.tar.gz"
	KEYWORDS="~arm"
	S="${WORKDIR}/${P}-${MY_PR}"
else
	inherit git-r3
	EGIT_REPO_URI="http://anongit.freedesktop.org/git/xorg/driver/xf86-video-armsoc.git"
	EGIT_COMMIT="1.3.1"
	#EGIT_REPO_URI="https://github.com/mdrjr/xf86-video-armsoc.git
	#	git@github.com:mdrjr/xf86-video-armsoc.git"
	## release branch for github tarballs: r4p0-umplock
	## alternate 5422 branch is more active: 5422_r5p1
	#EGIT_BRANCH="5422_r5p1"
fi

DESCRIPTION="Open-source X.org graphics driver for ARM graphics"
HOMEPAGE="https://github.com/mdrjr/xf86-video-armsoc"
LICENSE="MIT"

RDEPEND="virtual/udev
	>=x11-base/xorg-server-1.10
	>=x11-libs/pixman-0.32.6
	>=x11-libs/libump-3.0
	>=x11-libs/libdrm-2.4.60[video_cards_exynos]"

DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-proto/fontsproto
	x11-proto/dri2proto"

# Best way to jam this into the config parameter?
#IUSE="exynos pl111"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

src_prepare() {
	sed -i -e "s|ERROR_CFLAGS = -Werror|ERROR_CFLAGS = |" \
		 "${S}"/Makefile.am "${S}"/src/Makefile.am \
		|| die "could not tweak makefile.am!"

	epatch "${FILESDIR}"/${PN}-implicit_declaration.patch

	xorg-2_src_prepare
}

src_install() {
	xorg-2_src_install

	insinto /etc/udev/rules.d
	doins "${FILESDIR}"/50-ump.rules
}
