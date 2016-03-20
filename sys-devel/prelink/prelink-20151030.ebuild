# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils flag-o-matic

DESCRIPTION="Modifies ELFs to avoid runtime symbol resolutions resulting in faster load times"
HOMEPAGE="https://www.yoctoproject.org/tools-resources/projects/cross-prelink"

SRC_URI="http://git.yoctoproject.org/cgit/cgit.cgi/prelink-cross/snapshot/${PN}-cross-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -arm ~ppc ~ppc64 ~x86"
IUSE="selinux"

DEPEND=">=dev-libs/elfutils-0.100[static-libs(+)]
	selinux? ( sys-libs/libselinux[static-libs(+)] )
	!dev-libs/libelf
	>=sys-libs/glibc-2.8"
RDEPEND="${DEPEND}
	>=sys-devel/binutils-2.18"

S=${WORKDIR}/${PN}-cross-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20130503-prelink-conf.patch
	epatch "${FILESDIR}"/${PN}-20130503-libiberty-md5.patch

	sed -i -e '/^CC=/s: : -Wl,--disable-new-dtags :' testsuite/functions.sh #100147
	# >=binutils-2.22 --no-copy-dt-needed-entries is the default
	# --copy-dt-needed-entries was renamed from --add-needed in 2.21, use the
	# former so we don't have to bump the dep
	sed -i \
		-e '/CCLINK=/s:CCLINK="$(CC):& -Wl,--add-needed :' \
		-e '/CXXLINK=/s:CXXLINK="$(CXX):& -Wl,--add-needed :' \
		testsuite/Makefile.am

	has_version 'dev-libs/elfutils[threads]' && append-ldflags -pthread

	eautoreconf # prevent maintainer mode

	# have to do this after eautoreconf or automake barfs on the trailing
	# backslash of the previous line
	sed -i -e 's:undosyslibs.sh::' testsuite/Makefile.in #254201

	export ac_cv_{header_selinux_selinux_h,lib_selinux_is_selinux_enabled}=$(usex selinux)
}

src_install() {
	default

	insinto /etc
	doins doc/prelink.conf

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/prelink.cron prelink
	newconfd "${FILESDIR}"/prelink.confd prelink
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ] ; then
		elog "You may wish to read the Gentoo Linux Prelink Guide, which can be"
		elog "found online at:"
		elog "    https://wiki.gentoo.org/wiki/Prelink"
		elog "Please edit /etc/conf.d/prelink to enable and configure prelink"
	fi
}

