# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils x-modular

DESCRIPTION="Xorg/Freedesktop driver for NVIDIA Tegra GPUs"
SRC_URI="http://cgit.freedesktop.org/xorg/driver/xf86-video-opentegra/snapshot/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10"

DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xproto"

src_prepare() {
	eautoreconf
}

