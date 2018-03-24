# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="http://dri.freedesktop.org/"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"
	#EGIT_REPO_URI="https://github.com/Gnurou/drm.git"
	#EGIT_BRANCH="fb_modifiers"
else
	SRC_URI="http://dri.freedesktop.org/${PN}/${P}.tar.bz2"
fi

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux"
VIDEO_CARDS="amdgpu exynos freedreno intel nouveau omap radeon tegra vc4 vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} linux-headers libkms valgrind"
RESTRICT="test" # see bug #236845

RDEPEND=">=dev-libs/libpthread-stubs-0.3-r1:=[${MULTILIB_USEDEP}]
	video_cards_intel? ( >=x11-libs/libpciaccess-0.13.1-r1:=[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)] )
	linux-headers? ( >=sys-kernel/linux-headers-4.0 )"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"

PATCHES=(
	"${FILESDIR}"/${PN}-arm-update.patch
)

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		# tests are restricted, no point in building them
		sed -ie 's/tests //' "${S}"/Makefile.am
		# update version string so mesa is happy
		sed -ie 's/2.4.74/2.4.75/' "${S}"/configure.ac
	fi
	xorg-2_src_prepare
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		# Udev is only used by tests now.
		--disable-udev
		--disable-cairo-tests
		$(use_enable video_cards_amdgpu amdgpu)
		$(use_enable video_cards_vivante etnaviv-experimental-api)
		$(use_enable video_cards_exynos exynos-experimental-api)
		$(use_enable video_cards_freedreno freedreno)
		$(use_enable video_cards_intel intel)
		$(use_enable video_cards_nouveau nouveau)
		$(use_enable video_cards_omap omap-experimental-api)
		$(use_enable video_cards_radeon radeon)
		$(use_enable video_cards_tegra tegra-experimental-api)
		$(use_enable video_cards_vc4 vc4)
		$(use_enable video_cards_vmware vmwgfx)
		$(use_enable libkms)
		# valgrind installs its .pc file to the pkgconfig for the primary arch
		--enable-valgrind=$(usex valgrind auto no)
	)

	xorg-2_src_configure
}

src_install() {
	xorg-2_src_install

	file_collides="drm_fourcc.h drm.h drm_mode.h drm_sarea.h i915_drm.h
		mga_drm.h nouveau_drm.h qxl_drm.h r128_drm.h radeon_drm.h
		savage_drm.h sis_drm.h tegra_drm.h via_drm.h"

	if [ has_version '>=sys-kernel/linux-headers-4.0' ] && [ use linux-headers ] ; then
		for file in $file_collides ; do
			find "${ED}" -name $file -type f -print0 \
				| xargs -0 /bin/rm -f
		done
	fi
}
