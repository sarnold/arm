# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Simple program to read/write from/to any location in memory."
HOMEPAGE="http://www.lartmaker.nl/lartware/port/"

SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~arm"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""

src_compile() {
	emake CC=$(tc-getCC) || die "make failed..."
}

