# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/grate-driver/grate.git"

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git-2

DESCRIPTION="Grate: open source Tegra 2D/3D user-space libraries"
HOMEPAGE="https://github.com/grate-driver"

KEYWORDS="~arm ~arm-linux"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/libX11
	media-libs/libpng
	media-libs/mesa[egl,gles1,gles2]
	x11-proto/xproto
	x11-libs/libdrm
	!sys-apps/tcp-wrappers"

DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		--with-pic
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install
}

