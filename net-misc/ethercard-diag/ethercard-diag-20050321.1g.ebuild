# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="low level mii diagnostic tools including mii-diag and etherwake (merge of netdiag/isa-diag)"
HOMEPAGE="ftp://ftp.scyld.com/pub/diag/ ftp://ftp.scyld.com/pub/isa-diag/"
SRC_URI="mirror://gentoo/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+diag-only"

DEPEND="!sys-apps/nictools"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-make_diag_only.patch \
		"${S}"/patches/000*.patch

	# triggers QA warnings, needs fixing...
	sed -i -e "s|pcnet-diag ||" "${S}"/pub/diag/Makefile
	rm -f "${S}"/pub/diag/pcnet-diag*
}

src_compile() {
	tc-export CC AR
	if ! use diag-only ; then
		emake || die
	else
		emake diag || die
	fi
}

src_install() {
	if ! use diag-only ; then
		emake DESTDIR="${D}" install || die
	else
		emake DESTDIR="${D}" install-diag || die
	fi

	dodir /sbin
	mv "${D}"/usr/sbin/{mii-diag,ether-wake} "${D}"/sbin/ || die
}
