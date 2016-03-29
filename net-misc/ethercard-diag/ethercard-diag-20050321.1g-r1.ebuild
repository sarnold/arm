# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="low level mii diagnostic tools including mii-diag and etherwake (merge of netdiag/isa-diag)"
HOMEPAGE="ftp://ftp.scyld.com/pub/diag/ ftp://ftp.scyld.com/pub/isa-diag/"
SRC_URI="mirror://gentoo/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE="+diag-only"

RDEPEND="!sys-apps/nictools"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-make_diag_only.patch \
		"${S}"/patches/000*.patch

	# triggers QA warnings, needs fixing...
	sed -i -e "s|pcnet-diag ||" "${S}"/pub/diag/Makefile
	rm -f "${S}"/pub/diag/pcnet-diag*

	# Since the binary is `ether-wake`, make sure the man page is
	# `man ether-wake` and not `man etherwake`. #439504
	sed -i \
		-e 's/ETHERWAKE/ETHER-WAKE/' \
		-e 's/etherwake/ether-wake/' \
		pub/diag/{etherwake.8,Makefile} patches/* || die
	mv pub/diag/ether{,-}wake.8 || die
}

src_compile() {
	tc-export CC AR
	append-cflags "-DPIC -fPIC"
	strip-flags "-O*"
	tc-ld-disable-gold
	if ! use diag-only ; then
		emake
	else
		emake diag
	fi
}

src_install() {
	if ! use diag-only ; then
		emake DESTDIR="${D}" install
	else
		emake DESTDIR="${D}" install-diag
	fi

	dodir /sbin
	mv "${D}"/usr/sbin/{mii-diag,ether-wake} "${D}"/sbin/ || die
}
