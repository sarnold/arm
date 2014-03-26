# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools

DESCRIPTION="Get EDID information from a PnP monitor"
HOMEPAGE="http://www.polypux.org/projects/read-edid/"
SRC_URI="http://www.polypux.org/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 arm ppc ~sparc x86"

IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --mandir=/usr/share/man || die "configure failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	elog "Note: only parse-edid is built on non-x86 platforms."
	elog "Use it to parse the edid data in /sys like so:"
	elog " $ parse-edid /sys/class/drm/card0/card0-HDMI-A-1/edid"
}
