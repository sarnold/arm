# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/redis-ipc"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	IUSE="static"
fi

DESCRIPTION="A wrapper library for using redis server and JSON as IPC mechanism"
HOMEPAGE="https://github.com/VCTLabs/redis-ipc"

LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/pkgconfig
	dev-libs/hiredis
	dev-libs/json-c"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-qa-warning.patch" \
		"${FILESDIR}/${P}-autotools-updates.patch"

	export ac_cv_prog_STRIP="$(type -P true ) faking strip"

	eautoreconf
}

src_configure() {
	ECONF_SOURCE=${S} \
        STRIP=/bin/true \
        econf \
                $(use_enable static) \
                "${myconf[@]}"
}

