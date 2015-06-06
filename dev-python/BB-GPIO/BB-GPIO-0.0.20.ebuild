# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
inherit distutils-r1

MY_PN="Adafruit_BBIO"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}"/${MY_P}

DESCRIPTION="A Python module to control the GPIO on BeagleBone"
HOMEPAGE="https://pypi.python.org/pypi/Adafruit_BBIO"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/adafruit/adafruit-beaglebone-io-python.git"
	inherit git-2
	KEYWORDS=""
	EGIT_SOURCEDIR="${WORKDIR}/adafruit-beaglebone-io-python"
else
	SRC_URI="https://pypi.python.org/packages/source/A/${MY_PN}/${MY_P}.tar.gz"
	KEYWORDS="~arm"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=">=sys-apps/dtc-1.4.0"

