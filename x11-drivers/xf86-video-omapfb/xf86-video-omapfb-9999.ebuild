# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
XORG_DRI=always

EGIT_REPO_URI="https://github.com/sarnold/${PN}.git"

inherit autotools-utils xorg-2 git-2

DESCRIPTION="OMAP video driver"

KEYWORDS="~arm"

RDEPEND=">=x11-base/xorg-server-1.3
	>=x11-libs/libdrm-2.4.36[video_cards_omap]"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

