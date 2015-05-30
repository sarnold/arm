# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2 toolchain-funcs virtualx multilib-minimal

HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
DESCRIPTION="Clutter is a library for creating graphical user interfaces"

LICENSE="LGPL-2.1+ FDL-1.1+"
SLOT="1.0"
IUSE="aqua debug doc egl gtk +introspection test wayland +X"
REQUIRED_USE="
	|| ( aqua wayland X )
	wayland? ( egl )
"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# XXX: uprof needed for profiling
# >=libX11-1.3.1 needed for X Generic Event support
# do not depend on tslib, it does not build and is disable by default upstream
RDEPEND="
	>=dev-libs/glib-2.37.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.5.3[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/json-glib-0.12[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.14:=[aqua?,glib,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.30[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/cogl-1.20.0[introspection?,pango,wayland?,${MULTILIB_USEDEP}]

	virtual/opengl
	x11-libs/libdrm:=[${MULTILIB_USEDEP}]

	egl? (
		>=dev-libs/libinput-0.8
		media-libs/cogl[gles2,kms]
		>=virtual/libgudev-136
		x11-libs/libxkbcommon
	)
	gtk? ( >=x11-libs/gtk+-3.3.18:3[aqua?,${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	X? (
		media-libs/fontconfig[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.3.1[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-proto/inputproto[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.3[${MULTILIB_USEDEP}]
		>=x11-libs/libXcomposite-0.4[${MULTILIB_USEDEP}] )
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.17
	>=virtual/pkgconfig-0-r1
	doc? (
		>=dev-util/gtk-doc-1.20
		>=app-text/docbook-sgml-utils-0.6.14[jadetex,${MULTILIB_USEDEP}]
		dev-libs/libxslt[${MULTILIB_USEDEP}] )
	test? ( x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}] )"

# Tests fail with both swrast and llvmpipe
# They pass under r600g or i965, so the bug is in mesa
#RESTRICT="test"

src_prepare() {
	# We only need conformance tests, the rest are useless for us
	sed -e 's/^\(SUBDIRS =\).*/\1 accessibility conform/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\)[^\]*/\1  accessibility conform/g' \
		-i tests/Makefile.in || die "in tests sed failed"

	gnome2_src_prepare
}

multilib_src_configure() {
	tc-export PKG_CONFIG
	PKG_CONFIG_LIBDIR="${EPREFIX}/usr/$(get_libdir)/pkgconfig"

	local myopts

	if ! multilib_is_native_abi; then
		myopts+=" --disable-egl-backend --disable-evdev-input --disable-introspection"
	fi

	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# (GLX error blabla)
	# XXX: Profiling, coverage disabled for now
	# XXX: What about cex100/win32 backends?
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-profile \
		--disable-maintainer-flags \
		--disable-gcov \
		--disable-cex100-backend \
		--disable-win32-backend \
		--disable-tslib-input \
		$(use_enable aqua quartz-backend) \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable doc docs) \
		$(use_enable egl egl-backend) \
		$(use_enable egl evdev-input) \
		$(use_enable gtk gdk-backend) \
		$(use_enable introspection) \
		$(use_enable test gdk-pixbuf) \
		$(use_enable wayland wayland-backend) \
		$(use_enable wayland wayland-compositor) \
		$(use_enable X xinput) \
		$(use_enable X x11-backend) \
		${myopts}
}

multilib_src_test() {
	Xemake check -C tests/conform
}
