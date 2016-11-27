# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils toolchain-funcs

MY_PV="v${PV}"

DESCRIPTION="Tools for C.H.I.P. and Allwinner A10 devices."
HOMEPAGE="https://github.com/NextThingCo"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/sunxi-tools.git"
	EGIT_BRANCH="master"
	## switch to branch below to build NextThing fork
	#EGIT_BRANCH="chip-master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/sunxi-tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="virtual/libusb"

src_compile() {
	emake CC="$(tc-getCC)" all misc
}

src_install() {
	dobin bin2fex fex2bin phoenix_info
	newbin sunxi-bootinfo bootinfo
	newbin sunxi-fel fel
	newbin sunxi-fexc fexc
	newbin sunxi-nand-part nand-part
	newbin sunxi-pio pio
}
