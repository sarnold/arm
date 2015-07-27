# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
XORG_DRI=always

EGIT_REPO_URI="https://github.com/ssvb/xf86-video-fbturbo.git"

inherit autotools-utils xorg-2 git-2

DESCRIPTION="FBTurbo ARM video driver (based on sunxifb)"

KEYWORDS="~arm"

RDEPEND=">=x11-base/xorg-server-1.3
	gles2? (
		( >=x11-libs/libdrm-2.4.36[video_cards_exynos] )
		( x11-libs/libump )
		)"

DEPEND="${RDEPEND}"

IUSE="gles2"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

