# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
VALA_MIN_API_VERSION="0.16"

inherit waf-utils vala

DESCRIPTION="A lightweight vala based terminal"
HOMEPAGE="http://freesmartphone.org/"
SRC_URI="https://github.com/freesmartphone/vala-terminal/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:3
	x11-libs/vte:2.91"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
		)"

DOCS="AUTHORS ChangeLog README TODO"

src_configure() {
	local myconf
	use nls || myconf='--disable-nls'
	waf-utils_src_configure --custom-flags --verbose ${myconf}
}
