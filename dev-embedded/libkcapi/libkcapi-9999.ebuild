# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#WANT_AUTOMAKE="1.15.1"

inherit autotools ltprune toolchain-funcs

DESCRIPTION="Linux Kernel Crypto API User Space Interface Library"
HOMEPAGE="http://www.chronox.de/libkcapi.html"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/smuellerDD/libkcapi.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/smuellerDD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE="pic"

DEPEND="dev-libs/openssl:=
	dev-libs/check
	app-text/xmlto"

RDEPEND="${DEPEND}"

DOCS=( README.md )

RESTRICT="test"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-kcapi-rngapp
		--enable-kcapi-encapp
		--enable-kcapi-dgstapp
		$(use_with pic)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	prune_libtool_files --all
}
