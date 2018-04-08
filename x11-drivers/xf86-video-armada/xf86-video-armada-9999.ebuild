# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

XORG_BASE_INDIVIDUAL_URI=""
#EGIT_REPO_URI="http://git.arm.linux.org.uk/cgit/xf86-video-armada.git"
EGIT_REPO_URI="https://github.com/VCTLabs/xf86-video-armada"
XORG_DRI="always"

inherit xorg-2 git-r3

if [[ ${PV} = 9999 ]]; then
	#EGIT_BRANCH="unstable-devel"
	EGIT_BRANCH="devel"
	KEYWORDS="~arm"
else
	EGIT_COMMIT="87e9fa065c8aa82715a2941ebb8d3af73b145263"
	KEYWORDS="~arm"
	DEPEND_COMMON="x11-libs/libetnaviv"
fi

DESCRIPTION="Xorg graphics driver for KMS based systems with pluggable GPU backend"
IUSE="-etnaviv"

RDEPEND=">=x11-base/xorg-server-1.18"

DEPEND="${RDEPEND}
	x11-libs/libdrm-armada
	${DEPEND_COMMON}
"

pkg_setup() {
	xorg-2_pkg_setup

	# note: vivante requires libGAL
	# and with-etnaviv-source is only on devel branch
	#--with-etnaviv-source="${S}"/etna_viv
	XORG_CONFIGURE_OPTIONS=(
		--disable-vivante
		$(use_enable etnaviv)
		--with-etnaviv-source="${S}"/etna_viv
	)
}
