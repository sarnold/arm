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
	MY_PV=$(replace_all_version_separators '_' )
	SRC_URI="https://github.com/etnaviv/galcore_headers/archive/master.zip -> ${P}.zip"
	KEYWORDS="~arm"
	IUSE="imx"
fi

DESCRIPTION="GAL headers for the Vivante and other embedded GPUs"
HOMEPAGE="https://github.com/etnaviv/etna_viv"

LICENSE="MIT"
SLOT="0"

DEPEND=""

MERGE_TYPE="binary"

src_install() {
	if use imx; then
		insinto /usr/include/HAL
		if [ "${PV}" = "9999" ]; then
			doins -r include_imx6*
		else
			doins include_imx6_v"${MY_PV}"
		fi
	fi
}

