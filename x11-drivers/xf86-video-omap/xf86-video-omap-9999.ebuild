# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

XORG_DRI=always

inherit autotools-utils xorg-2 git-2

EGIT_REPO_URI="git://git.freedesktop.org/git/xorg/driver/xf86-video-omap"

DESCRIPTION="OMAP video driver"

KEYWORDS="arm"

RDEPEND=">=x11-base/xorg-server-1.3
	>=x11-libs/libdrm-2.4.36[video_cards_omap]"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

src_prepare() {
	test -d "${S}"/m4 || mkdir "${S}"/m4
	autotools-utils_src_prepare
}
