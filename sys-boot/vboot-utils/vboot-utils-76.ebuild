# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

# This is the name of the latest release branch.
RELEASE="release-R76-12239.B"

DESCRIPTION="Chrome OS verified boot tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/ https://dev.chromium.org/chromium-os/chromiumos-design-docs/verified-boot"
# Can't use gitiles directly until b/19710536 is fixed.
#SRC_URI="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+archive/refs/heads/${RELEASE}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+archive/refs/heads/${RELEASE}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="libressl libzip minimal static"

LIB_DEPEND="
	libzip? ( dev-libs/libzip:=[static-libs(+)] )
	dev-libs/libyaml:=[static-libs(+)]
	app-arch/xz-utils:=[static-libs(+)]"
LIB_DEPEND_MINIMAL="
	!libressl? ( dev-libs/openssl:0=[static-libs(+)] )
	libressl? ( dev-libs/libressl:0=[static-libs(+)] )
	libzip? ( dev-libs/libzip:=[static-libs(+)] )
	sys-apps/util-linux:=[static-libs(+)]"
RDEPEND="!static? (
		${LIB_DEPEND_MINIMAL//\[static-libs(+)]}
		!minimal? ( ${LIB_DEPEND//\[static-libs(+)]} )
	)
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}
	static? (
		${LIB_DEPEND_MINIMAL}
		!minimal? ( ${LIB_DEPEND} )
	)
	app-crypt/trousers"

S=${WORKDIR}

src_prepare() {
	# Bug #687820
	use elibc_musl && eapply "${FILESDIR}"/${P}-musl-fts.patch

	default
	sed -i \
		-e 's:${DESTDIR}/\(bin\|${LIBDIR}\):${DESTDIR}/usr/\1:g' \
		-e 's:${DESTDIR}/default:${DESTDIR}/etc/default:g' \
		-e 's:${TEST_INSTALL_DIR}/bin:${TEST_INSTALL_DIR}/usr/bin:' \
		-e '/cgpt -D 358400/d' \
		Makefile || die
	sed -e 's:^BIN_DIR=${BUILD_DIR}/install_for_test/bin:BIN_DIR=${BUILD_DIR}/install_for_test/usr/bin:' \
		-i tests/common.sh || die
	sed -e "s:/mnt/host/source/src/platform/vboot_reference:${S}:" \
		-i tests/futility/expect_output/* || die
}

_emake() {
	local arch=$(tc-arch)
	emake \
		V=1 \
		QEMU_ARCH= \
		ARCH=${arch} \
		HOST_ARCH=${arch} \
		LIBDIR="$(get_libdir)" \
		DEBUG_FLAGS= \
		WERROR= \
		MINIMAL=$(usev minimal) \
		STATIC=$(usev static) \
		$(usex elibc_musl HAVE_MUSL=1 "") \
		"$@"
}

src_compile() {
	tc-export CC AR CXX PKG_CONFIG
	_emake TEST_BINS= all
}

src_test() {
	_emake runtests
}

src_install() {
	_emake DESTDIR="${ED}" install

	insinto /usr/share/vboot/devkeys
	doins tests/devkeys/*

	insinto /usr/include/vboot
	doins host/include/* \
		firmware/include/gpt.h \
		firmware/include/tlcl.h \
		firmware/include/tss_constants.h

	dolib.a build/libvboot_host.a

	dodoc README
}
