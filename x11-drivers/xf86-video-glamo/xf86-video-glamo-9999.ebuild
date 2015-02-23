# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

EGIT_REPO_URI="git://git.openmoko.org/git/xf86-video-glamo.git"
EGIT_PROJECT="xf86-video-glamo"

inherit autotools-utils xorg-2 git-2

DESCRIPTION="Openmoko driver for freerunner devices"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="-* ~arm"

RDEPEND=">=x11-base/xorg-server-1.5"

DEPEND="${RDEPEND}
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/videoproto
	=x11-libs/libdrm-2.4.20[video_cards_glamo]"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"
CONFIGURE_OPTIONS="--enable-kms"

#src_prepare() {
#	test -d "${S}"/m4 || mkdir "${S}"/m4
#	autotools-utils_src_prepare
#}
