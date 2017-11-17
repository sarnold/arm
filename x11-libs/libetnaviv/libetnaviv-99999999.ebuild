# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

MY_PN="${PN/_/}"
P="${MY_PN}-${PV}"

if [ "${PV}" = "99999999" ]; then
	EGIT_REPO_URI="git://github.com/etnaviv/etna_viv"
	inherit git-r3
	EGIT_COMMIT="f64d77abbb54433bd5de955c20afddc6eb4f4cb1"
	KEYWORDS=""
	IUSE="src"
else
	# this commit is 1 before the attic-move; if you want to try
	# building the src, you might start here...
	COMMIT_ID="3815bcc09ccef173987f2d346a947a9b7e502762"
	SRC_URI="https://github.com/etnaviv/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}-git.tar.gz"
	KEYWORDS="~arm"
	IUSE=""
	S=${WORKDIR}/${PN}-${COMMIT_ID}
fi

DESCRIPTION="FOSS driver headers for the Vivante GCxxx series of embedded GPUs"
HOMEPAGE="https://github.com/etnaviv/etna_viv"

LICENSE="MIT"
SLOT="0"

DEPEND=">=x11-libs/libdrm-2.4.74:=[video_cards_vivante]
	virtual/pkgconfig"

MERGE_TYPE="binary"

#S="${WORKDIR}/${P}"

src_install() {
	insinto /usr/include/etnaviv

	if use src; then
		doins -r src attic
	else
		doins src/etnaviv/*.h attic/etnaviv/*.h
	fi
}

