# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

MY_PN="${PN/./-}"
MY_PV="${PV//_alpha/a}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A Python module to control the GPIO on a Raspberry Pi"
HOMEPAGE="http://sourceforge.net/projects/raspberry-gpio-python/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/RPi.GPIO.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/raspberry-gpio-python/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
