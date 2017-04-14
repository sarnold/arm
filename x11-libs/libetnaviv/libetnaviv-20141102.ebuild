# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_PN="${PN/_/}"
P="${MY_PN}-${PV}"

if [ "${PV}" = "99999999" ]; then
	EGIT_REPO_URI="git://github.com/etnaviv/etna_viv"
	inherit git-r3
	KEYWORDS=""
	MERGE_TYPE="binary"
else
	# Note this is the legacy library plus headers
	COMMIT_ID="60105d1b0755e48b37d779d8a2b9c4b458b5a2fd"
	SRC_URI="https://github.com/etnaviv/libetnaviv/archive/master.zip -> ${P}.zip"
	KEYWORDS="~arm"
	IUSE=""
	S=${WORKDIR}/${PN}-master
fi

DESCRIPTION="FOSS driver headers and library for the Vivante GCxxx series of embedded GPUs"
HOMEPAGE="https://github.com/etnaviv/etna_viv"

LICENSE="MIT"
SLOT="0"

DEPEND=">=x11-libs/libdrm-2.4.75:=[video_cards_vivante]
	~media-libs/galcore-headers-4.6.6
	x11-proto/xproto
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	myeconf=( --with-galcore-include=/usr/include/HAL )

	econf "${myeconf[@]}"
}

src_install() {
	if [ "${PV}" = "99999999" ]; then
		insinto /usr/include/etnaviv
		doins src/etnaviv/*.h attic/etnaviv/*.h
	else
		default
		prune_libtool_files --all
	fi
}

