# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU Public License v2

EAPI="5"

EGIT_REPO_URI="https://chromium.googlesource.com/chromiumos/third_party/${PN}.git"
#EGIT_REPO_URI="git://git.linaro.org/arm/xorg/driver/xf86-video-armsoc.git"
#EGIT_COMMIT="8613894e87e74a4d21ba78b8a50bb3733e53b93d"
EGIT_BRANCH="factory-daisy-4731.81.B"

## This can use a hefty patch for modern xorg (eg, 1.17 or so) especially
## since the old commit above doesn't even clone...

XORG_DRI="always"
XORG_EAUTORECONF="yes"
XORG_CONFIGURE_OPTIONS="--with-driver=exynos"

inherit xorg-2 git-r3 eutils flag-o-matic

DESCRIPTION="X.Org driver for ARM devices"

RDEPEND=">=x11-base/xorg-server-1.9
	!x11-drivers/mali-drivers"

DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
#	epatch "${FILESDIR}"/0001-Import-patch-from-Marcin.patch
	epatch "${FILESDIR}"/remove-mibstore-header-include.patch
	xorg-2_src_prepare
}

src_configure() {
	append-cflags -Wno-error
	xorg-2_src_configure
}
