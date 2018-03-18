# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="https://github.com/sarnold/libdrm-armada.git"
## upstream doesn't have patch yet
# git://git.armlinux.org.uk/~rmk/libdrm-armada.git

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git-2

DESCRIPTION="Armada/etnaviv libdrm buffer object management module"
HOMEPAGE="http://git.armlinux.org.uk/cgit/libdrm-armada.git"

KEYWORDS="~arm ~arm-linux"
SLOT="0"
IUSE="static-libs"

RDEPEND="media-libs/mesa[egl,gles1,gles2]"

DEPEND="${RDEPEND}
	>=x11-libs/libdrm-2.4.74:=[video_cards_vivante]"

#AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	autotools-utils_src_configure $(use_enable static-libs static)
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install
}

