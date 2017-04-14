# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/grate-driver/grate.git"

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git-2

DESCRIPTION="Grate: open source Tegra 2D/3D user-space libraries"
HOMEPAGE="https://github.com/grate-driver"

KEYWORDS="~arm ~arm-linux"
SLOT="0"
IUSE="static"

RDEPEND="x11-libs/libX11
	media-libs/libpng
	media-libs/devil
	media-libs/mesa[egl,gles1,gles2]
	x11-proto/xproto
	x11-libs/libdrm
	x11-libs/xcb-util-image
	!sys-apps/tcp-wrappers"

DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		--with-pic
	)

	export ac_cv_prog_STRIP="$(type -P true ) faking strip"

	ECONF_SOURCE=${S} \
	STRIP=/bin/true \
	econf \
		$(use_enable static) \
		"${myeconfargs[@]}"
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install
}

