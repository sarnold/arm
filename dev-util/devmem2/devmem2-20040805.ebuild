# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Simple program to read/write from/to any location in memory."
HOMEPAGE="http://www.lartmaker.nl/lartware/port/"

KEYWORDS="~arm"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""

S="${WORKDIR}"

src_unpack() {
	cp "${FILESDIR}"/Makefile "${FILESDIR}"/devmem2.c "${S}"/
}

src_compile() {
	emake CC=$(tc-getCC) || die "make failed..."
}

src_install() {
	dobin "${WORKDIR}/devmem2" || die "install failed..."
}

