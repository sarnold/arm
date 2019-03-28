# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.32"

inherit autotools vala

DESCRIPTION="A lightweight vala based terminal"
HOMEPAGE="http://freesmartphone.org/"
SRC_URI="https://github.com/freesmartphone/vala-terminal/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls static-libs"

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:3
	dev-libs/gobject-introspection
	nls? ( virtual/libintl )
	x11-libs/vte:2.91[vala]"

DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS="AUTHORS ChangeLog README TODO"

PATCHES=(
		"${FILESDIR}/${P}-fix-desktop-file.patch"
		"${FILESDIR}/${P}-vte-2.9.1-support.patch"
	)

src_prepare() {
	default

	AM_OPTS="--force-missing" eautoreconf

	vala_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}
