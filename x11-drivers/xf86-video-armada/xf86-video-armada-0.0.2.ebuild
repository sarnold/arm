# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
XORG_BASE_INDIVIDUAL_URI=""
XORG_DRI="always"

inherit autotools-utils xorg-2

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/xf86-video-armada"
	EGIT_BRANCH="devel"
	KEYWORDS=""
	inherit git-r3
else
	SRC_URI="mirror://gentoo/${P}.tar.gz"
	KEYWORDS="~arm"
fi

DESCRIPTION="Xorg graphics driver for KMS based systems with pluggable GPU backend"

RDEPEND=">=x11-base/xorg-server-1.18"

DEPEND="${RDEPEND}
	x11-libs/libetnaviv
	x11-libs/libdrm-armada
"

pkg_setup() {
	xorg-2_pkg_setup

	# note: vivante requires libGAL
	XORG_CONFIGURE_OPTIONS=(
		--disable-vivante
		--enable-etnaviv
	)
}
