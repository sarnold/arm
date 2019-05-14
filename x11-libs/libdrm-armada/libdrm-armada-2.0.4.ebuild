# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AUTOTOOLS_AUTORECONF=1

inherit autotools eutils

DESCRIPTION="Armada/etnaviv libdrm buffer object management module"
HOMEPAGE="http://git.armlinux.org.uk/cgit/libdrm-armada.git"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/libdrm-armada.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm ~arm-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE="static-libs"

RDEPEND="media-libs/mesa[egl,gles1,gles2]"

DEPEND="${RDEPEND}
	>=x11-libs/libdrm-2.4.74:=[video_cards_vivante]"

RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}
