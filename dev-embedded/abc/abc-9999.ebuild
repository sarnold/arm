# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="An FPGA logic verification tool."
HOMEPAGE="https://people.eecs.berkeley.edu/~alanmi/abc/"

EGIT_REPO_URI="https://github.com/berkeley-abc/abc.git"
EGIT_BRANCH="master"
EGIT_COMMIT="62180f357678df2be0b678bec33ac8e8b36945b8"

KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE="c++ debug static-libs"

DEPEND="
	sys-libs/readline:=
	sys-libs/ncurses:=
"

RDEPEND="${DEPEND}
	sci-visualization/gnuplot
	media-gfx/graphviz
	app-text/gv
"

PATCHES=( "${FILESDIR}/${PN}-makefile-fixes.patch" )

src_compile() {
	tc-export CC CXX AR
	use debug || OPTFLAGS=""

	local myopts
	if use c++; then
		myopts="ABC_USE_NAMESPACE=xxx"
	else
		myopts="ABC_USE_STDINT_H=1"
	fi

	ABC_MAKE_VERBOSE=1 emake "${myopts}" ABC_USE_PIC=1 abc
	use static-libs && emake "${myopts}" ABC_USE_PIC=1 libabc.a
	#ABC_MAKE_VERBOSE=1 emake "${myopts}" abc
}

src_install() {
	dobin abc
	dolib.so libabc.so*
	use static-libs && dolib.a libabc.a

	einfo "Installing base headers required for abc"
	local header
	pushd "${S}"/src/base > /dev/null
		find . -name '*.h' | \
		while read header ; do
			mkdir -p "${ED}/usr/include/abc/$(dirname ${header})" || die
			cp ${header} "${ED}/usr/include/abc/$(dirname ${header})" || die
		done
	popd > /dev/null
}

src_test() {
	emake test
}
