# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit versionator

MY_PN="${PN/_/-}"
P="${MY_PN}-${PV}"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/etnaviv/galcore_headers.git"
	KEYWORDS=""
else
	SRC_URI="mirror://gentoo/${P}.tar.gz"
	KEYWORDS="~arm"
fi

DESCRIPTION="GAL headers for the Vivante and other embedded GPUs"
HOMEPAGE="https://github.com/etnaviv/etna_viv"

LICENSE="MIT"
SLOT="0"

DEPEND=""

MERGE_TYPE="binary"

src_install() {
	insinto /usr/include/HAL
	if [ "${PV}" = "9999" ]; then
		doins -r include_imx6*
	else
		doins include/*.h
	fi
}

