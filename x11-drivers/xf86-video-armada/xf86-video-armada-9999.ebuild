# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

XORG_BASE_INDIVIDUAL_URI=""
EGIT_REPO_URI="https://github.com/VCTLabs/xf86-video-armada"
XORG_DRI="always"

inherit xorg-2

DESCRIPTION="Xorg graphics driver for KMS based systems with pluggable GPU backend"
KEYWORDS="~arm"

RDEPEND=">=x11-base/xorg-server-1.17"

DEPEND="${RDEPEND}
	x11-libs/libdrm-armada
	x11-libs/libetnaviv
"

XORG_CONFIGURE_OPTIONS=(
	--disable-vivante
	--disable-etnaviv )
