# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit eutils distutils-r1

DESCRIPTION="Yosys - Yosys Open SYnthesis Suite"
HOMEPAGE="http://www.clifford.at/yosys/"
LICENSE="ISC"
SRC_URI="https://github.com/YosysHQ/${PN}/archive/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE="+abc"

DEPEND="
	dev-libs/boost:=[threads(+),context,python,${PYTHON_USEDEP}]
	media-gfx/graphviz:=[python,svg,tcl]
	sys-libs/readline:=
	dev-libs/libffi
	dev-vcs/git
	dev-lang/tcl:=
	${PYTHON_DEPS}
	abc? ( dev-embedded/abc )
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-apps/gawk
	virtual/pkgconfig
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"

PATCHES=( "${FILESDIR}/${P}-fix-missing-limits.patch" )

src_configure() {
	emake config-gcc
	echo "ENABLE_ABC := $(usex abc 1 0)" >> "${S}/Makefile.conf"
	use abc && echo "ABCEXTERNAL := abc" >> "${S}/Makefile.conf"
}

src_compile() {
	emake PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake STRIP="true" PREFIX="${ED}/usr" install
}
