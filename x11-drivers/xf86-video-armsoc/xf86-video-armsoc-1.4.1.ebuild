# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DRI="always"
XORG_EAUTORECONF="yes"
#XORG_CONFIGURE_OPTIONS="--with-drmmode=exynos --disable-selective-werror"

inherit autotools xorg-2 flag-o-matic

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/paolosabatino/xf86-video-armsoc.git"
else
	SRC_URI="https://github.com/paolosabatino/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm ~arm64"
fi

DESCRIPTION="Open-source X.org graphics driver for ARM graphics"
HOMEPAGE="https://github.com/mdrjr/xf86-video-armsoc"
LICENSE="MIT"

RDEPEND="virtual/udev
	>=x11-base/xorg-server-1.10
	>=x11-libs/pixman-0.32.6
	>=x11-libs/libdrm-2.4.60"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"
