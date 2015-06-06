# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}"/${MY_P}

DESCRIPTION="A Python module to control the GPIO on a Raspberry Pi"
HOMEPAGE="http://sourceforge.net/projects/raspberry-gpio-python/"
SRC_URI="mirror://sourceforge/raspberry-gpio-python/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

