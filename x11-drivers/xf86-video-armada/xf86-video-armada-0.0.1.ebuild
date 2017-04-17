# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

XORG_BASE_INDIVIDUAL_URI=""
EGIT_REPO_URI="https://github.com/VCTLabs/xf86-video-armada"
XORG_DRI="always"

inherit autotools xorg-2 git-r3

if [[ ${PV} = 9999 ]]; then
	EGIT_BRANCH="devel"
	KEYWORDS=""
else
	#EGIT_COMMIT="87e9fa065c8aa82715a2941ebb8d3af73b145263"
	EGIT_COMMIT="a5cdb15c7e2552327de4a79be86044d18b4cdad8"
	KEYWORDS="~arm"
fi

DESCRIPTION="Xorg graphics driver for KMS based systems with pluggable GPU backend"
IUSE="dri3"

RDEPEND=">=x11-base/xorg-server-1.18"

DEPEND="${RDEPEND}
	x11-libs/libdrm-armada
	x11-libs/libetnaviv
"

pkg_setup() {
	xorg-2_pkg_setup

	# note: vivante requires libGAL and other vendor-y stuff
	XORG_CONFIGURE_OPTIONS=(
		--disable-vivante
		--enable-etnaviv
		--enable-dri2
		$(use_enable dri3)
	)
}

src_prepare() {
	eautoreconf
}
