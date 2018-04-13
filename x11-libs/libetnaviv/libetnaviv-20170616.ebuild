# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools

MY_PN="${PN/_/}"
P="${MY_PN}-${PV}"

if [ "${PV}" = "99999999" ]; then
	EGIT_REPO_URI="git://github.com/etnaviv/etna_viv"
	inherit git-r3
	EGIT_COMMIT="f64d77abbb54433bd5de955c20afddc6eb4f4cb1"
	KEYWORDS=""
else
	SRC_URI="mirror://gentoo/${P}.tar.gz"
	KEYWORDS="~arm"
fi

DESCRIPTION="FOSS driver headers for the Vivante GCxxx series of embedded GPUs"
HOMEPAGE="https://github.com/etnaviv/etna_viv"

LICENSE="MIT"
SLOT="0"

DEPEND=">=x11-libs/libdrm-2.4.74:=[video_cards_vivante]
	virtual/pkgconfig"

MERGE_TYPE="binary"

src_install() {
	insinto /usr/include/etnaviv
	doins src/etnaviv/*.h attic/etnaviv/*.h
}

