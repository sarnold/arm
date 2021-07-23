# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune toolchain-funcs

DESCRIPTION="A client library for using redis as IPC msg/event bus."
HOMEPAGE="https://github.com/VCTLabs/redis-ipc"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/redis-ipc.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE="+pic static-libs"

DEPEND="dev-libs/hiredis:=
	dev-libs/json-c"

RDEPEND="${DEPEND}
	dev-db/redis"

DOCS=( README.rst )

# tests require a running redis server
RESTRICT="test"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with pic)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	prune_libtool_files --all
}
