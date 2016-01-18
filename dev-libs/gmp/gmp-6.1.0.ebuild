# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit flag-o-matic eutils libtool toolchain-funcs multilib-minimal

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="Library for arithmetic on arbitrary precision integers, rational numbers, and floating-point numbers"
HOMEPAGE="http://gmplib.org/"
SRC_URI="ftp://ftp.gmplib.org/pub/${MY_P}/${MY_P}.tar.xz
	mirror://gnu/${PN}/${MY_P}.tar.xz
	doc? ( http://gmplib.org/${PN}-man-${MY_PV}.pdf )"

LICENSE="|| ( LGPL-3+ GPL-2+ )"
# The subslot reflects the C & C++ SONAMEs.
SLOT="0/10.4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="+asm assert doc cxx fat pgo static-libs"

DEPEND="sys-devel/m4
	app-arch/xz-utils"
RDEPEND=""

S=${WORKDIR}/${MY_P%a}

REQUIRED_USE="fat? ( asm )"

DOCS=( AUTHORS ChangeLog NEWS README doc/configuration doc/isa_abi_headache )
HTML_DOCS=( doc )
MULTILIB_WRAPPED_HEADERS=( /usr/include/gmp.h )

src_prepare() {
	# this is still needed apparently...
	epatch "${FILESDIR}"/"${PN}"-configure-arm-double.patch

	[[ -d ${FILESDIR}/${PV} ]] && EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch "${FILESDIR}"/${PV}

	# note: we cannot run autotools here as gcc depends on this package
	elibtoolize

	# GMP uses the "ABI" env var during configure as does Gentoo (econf).
	# So, to avoid patching the source constantly, wrap things up.
	mv configure configure.wrapped || die
	cat <<-\EOF > configure
	#!/bin/sh
	exec env ABI="${GMPABI}" "$0.wrapped" "$@"
	EOF
	chmod a+rx configure

	# fails on arm with 6.0.0a but 6.1.0 seems to work, go figure...
	multilib_copy_sources
}

multilib_src_configure() {
	# Because of our 32-bit userland, 1.0 is the only HPPA ABI that works
	# http://gmplib.org/manual/ABI-and-ISA.html#ABI-and-ISA (bug #344613)
	if [[ ${CHOST} == hppa2.0-* ]] ; then
		export GMPABI="1.0"
	fi

	# ABI mappings (needs all architectures supported)
	case ${ABI} in
		32|x86)       GMPABI=32;;
		64|amd64|n64) GMPABI=64;;
		[onx]32)      GMPABI=${ABI};;
	esac
	export GMPABI

	if [[ ${CHOST} == armv* ]] ; then
	#	replace-flags -mfpu=neon* -mfpu=vfpv3-d16-fp16
		export gmp_cv_c_double_format="IEEE little endian"
	fi

	tc-export CC
	ECONF_SOURCE="${BUILD_DIR}" econf \
		--localstatedir="${EPREFIX}"/var/state/gmp \
		--enable-shared \
		--with-pic=yes \
		$(use_enable asm assembly) \
		$(use_enable assert) \
		$(use_enable cxx) \
		$(use_enable fat) \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	emake

	if use pgo ; then
		LIBS="-static ${S}/.libs/libgmp.a ${S}/tune/.libs/libspeed.a" \
		emake -j1 -C tune tuneup
		ebegin "Trying to generate tuned data"
		./tune/tuneup | tee gmp.mparam.h.new
		if eend $(( 0 + ${PIPESTATUS[*]/#/+} )) ; then
			mv gmp.mparam.h.new gmp-mparam.h || die
			emake clean
			emake
		fi
	fi
}

multilib_src_test() {
	emake check
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# should be a standalone lib
	rm -f "${D}"/usr/$(get_libdir)/libgmp.la
	# this requires libgmp
	local la="${D}/usr/$(get_libdir)/libgmpxx.la"
	use static-libs \
		&& sed -i 's:/[^ ]*/libgmp.la:-lgmp:' "${la}" \
		|| rm -f "${la}"
}

multilib_src_install_all() {
	einstalldocs
	use doc && cp "${DISTDIR}"/gmp-man-${MY_PV}.pdf "${D}"/usr/share/doc/${PF}/
}
