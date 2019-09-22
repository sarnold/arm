# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DRI=always
inherit autotools eutils xorg-2

MY_PV="v${PV}"

DESCRIPTION="Xorg/Freedesktop driver for NVIDIA Tegra GPUs"
#SRC_URI="https://gitlab.freedesktop.org/xorg/driver/xf86-video-opentegra/snapshot/${P}.tar.gz"
SRC_URI="https://gitlab.freedesktop.org/xorg/driver/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	eautoreconf
}

