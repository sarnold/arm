# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

EGIT_REPO_URI="git://gitorious.org/thierryreding/${PN}.git
	http://git.gitorious.org/thierryreding/${PN}.git"

inherit autotools-utils xorg-2 git-2

DESCRIPTION="Unaccelerated WIP driver for tegra devices"

KEYWORDS="-* ~arm"

RDEPEND=">=x11-base/xorg-server-1.15"

DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.0-DamageUnregister-fix.patch

	test -d "${S}"/m4 || mkdir "${S}"/m4
	autotools-utils_src_prepare
}
