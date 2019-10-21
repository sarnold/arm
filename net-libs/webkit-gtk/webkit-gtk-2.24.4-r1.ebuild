# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
USE_RUBY="ruby24 ruby25 ruby26"

inherit check-reqs cmake-utils flag-o-matic gnome2 llvm pax-utils python-any-r1 ruby-single toolchain-funcs virtualx

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.webkitgtk.org"
SRC_URI="https://www.webkitgtk.org/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="4/37" # soname version of libwebkit2gtk-4.0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x86-macos"

IUSE="aqua clang coverage doc +egl +geolocation gles2 gnome-keyring +gstreamer +introspection +jpeg2k libnotify lto nsplugin +opengl spell wayland +webgl +X"

# webgl needs gstreamer, bug #560612
# gstreamer with opengl/gles2 needs egl
REQUIRED_USE="
	geolocation? ( introspection )
	gles2? ( egl !opengl )
	gstreamer? ( opengl? ( egl ) )
	nsplugin? ( X )
	webgl? ( gstreamer
		|| ( gles2 opengl ) )
	wayland? ( egl )
	|| ( aqua wayland X )
"

# Tests fail to link for inexplicable reasons
# https://bugs.webkit.org/show_bug.cgi?id=148210
RESTRICT="test"

# Aqua support in gtk3 is untested
# Dependencies found at Source/cmake/OptionsGTK.cmake
# Various compile-time optionals for gtk+-3.22.0 - ensure it
# Missing OpenWebRTC checks and conditionals, but ENABLE_MEDIA_STREAM/ENABLE_WEB_RTC is experimental upstream (PRIVATE OFF)
# >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE)
RDEPEND="
	>=x11-libs/cairo-1.16.0:=[X?]
	>=media-libs/fontconfig-2.13.0:1.0
	>=media-libs/freetype-2.9.0:2
	>=dev-libs/libgcrypt-1.7.0:0=
	>=x11-libs/gtk+-3.22:3[aqua?,introspection?,wayland?,X?]
	>=media-libs/harfbuzz-1.4.2:=[icu(+)]
	>=dev-libs/icu-3.8.1-r1:=
	virtual/jpeg:0=
	>=net-libs/libsoup-2.48:2.4[introspection?]
	>=dev-libs/libxml2-2.8.0:2
	>=media-libs/libpng-1.4:0=
	dev-db/sqlite:3=
	sys-libs/zlib:0
	>=dev-libs/atk-2.8.0
	media-libs/libwebp:=

	>=dev-libs/glib-2.40:2
	>=dev-libs/libxslt-1.1.7
	media-libs/woff2
	gnome-keyring? ( app-crypt/libsecret )
	geolocation? ( >=app-misc/geoclue-2.1.5:2.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.32.0:= )
	dev-libs/libtasn1:=
	nsplugin? ( >=x11-libs/gtk+-2.24.10:2 )
	spell? ( >=app-text/enchant-0.22:= )
	gstreamer? (
		>=media-libs/gstreamer-1.14:1.0
		>=media-libs/gst-plugins-base-1.14:1.0[X?,egl?,gles2?,opengl?]
		>=media-plugins/gst-plugins-opus-1.14.4-r1:1.0
		>=media-libs/gst-plugins-bad-1.14:1.0 )

	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXrender
		x11-libs/libXt )

	libnotify? ( x11-libs/libnotify )
	dev-libs/hyphen
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2= )

	egl? ( media-libs/mesa[egl] )
	gles2? ( media-libs/mesa[gles2] )
	opengl? ( virtual/opengl )
	webgl? (
		x11-libs/libXcomposite
		x11-libs/libXdamage )
"

# paxctl needed for bug #407085
# Need real bison, not yacc
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=app-accessibility/at-spi2-core-2.5.3
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/gperf-3.0.1
	>=sys-devel/bison-2.4.3
	clang? ( >=sys-devel/clang-6:= )
	sys-devel/gettext
	virtual/pkgconfig

	>=dev-lang/perl-5.10
	virtual/perl-Data-Dumper
	virtual/perl-Carp
	virtual/perl-JSON-PP

	doc? ( >=dev-util/gtk-doc-1.10 )
	geolocation? ( dev-util/gdbus-codegen )
"
#	test? (
#		dev-python/pygobject:3[python_targets_python2_7]
#		x11-themes/hicolor-icon-theme
#		jit? ( sys-apps/paxctl ) )

LLVM_MAX_SLOT=8

S="${WORKDIR}/${MY_P}"

CHECKREQS_MEMORY="2G" # this much ram (eg, arm64) only works with -j1
CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

llvm_check_deps() {
	if use clang ; then
		if ! has_version --host-root "sys-devel/clang:${LLVM_SLOT}" ; then
			ewarn "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		if ! has_version --host-root "=sys-devel/lld-${LLVM_SLOT}*" ; then
			ewarn "=sys-devel/lld-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		einfo "Will use LLVM slot ${LLVM_SLOT}!"
	fi
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi

		if ! test-flag-CXX -std=c++11 ; then
			die "You need at least GCC 4.9.x or Clang >= 3.3 for C++11-specific compiler flags"
		fi

		if tc-is-gcc && [[ $(gcc-version) < 4.9 ]] ; then
			die 'The active compiler needs to be gcc 4.9 (or newer)'
		fi
	fi

	if ! use opengl && ! use gles2; then
		ewarn
		ewarn "You are disabling OpenGL usage (USE=opengl or USE=gles) completely."
		ewarn "This is an unsupported configuration meant for very specific embedded"
		ewarn "use cases, where there truly is no GL possible (and even that use case"
		ewarn "is very unlikely to come by). If you have GL (even software-only), you"
		ewarn "really really should be enabling OpenGL!"
		ewarn
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi

	python-any-r1_pkg_setup

	llvm_pkg_setup
}

src_prepare() {
	# fix build with -flto enabled
	eapply "${FILESDIR}"/"${PN}"-2.24.2-add-gcc-lto-pragma-fix.patch \
		"${FILESDIR}"/"${P}"-fix-clang-Wc++11-narrowing-errors.patch
	use arm && eapply "${FILESDIR}"/"${P}"-force-thumb-for-clang-on-armv7.patch
	cmake-utils_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	if use clang && ! tc-is-clang ; then
		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
		export LD=${CHOST}-clang++
	else
		tc-export CC
	fi

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	# ld segfaults on ia64 with LDFLAGS --as-needed, bug #555504
	use ia64 && append-ldflags "-Wl,--no-as-needed"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942 (see Fedora .spec for reference)
	# --no-keep-memory doesn't work on ia64, bug #502492
	if ! use ia64; then
		append-ldflags "-Wl,--no-keep-memory"
	fi

	# We try to use gold when possible for this package
	if ! tc-ld-is-gold ; then
		append-ldflags "-Wl,--reduce-memory-overheads"
	fi

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	for rubyimpl in ${USE_RUBY}; do
		if has_version "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ${rubyimpl})"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	[[ -z $ruby_interpreter ]] && die "No suitable ruby interpreter found"

	if use clang && ! tc-is-clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
#		LD=${CHOST}-clang++
#	elif ! use clang && ! tc-is-gcc ; then
#		# Force gcc
#		einfo "Enforcing the use of gcc due to USE=-clang ..."
#		CC=${CHOST}-gcc
#		CXX=${CHOST}-g++
	fi

	## TODO set lto thin here only if lto is enabled
	# Don't let user's LTO flags clash with upstream's flags
	#filter-flags -flto*

	if use lto ; then
		local show_old_compiler_warning=

		if use clang ; then
			# At this stage CC is adjusted and the following check will
			# will work
			if [[ $(clang-major-version) -lt 7 ]] ; then
				show_old_compiler_warning=1
			fi

			## this is light enough to build on arm with 4 GB of ram
			replace-flags -flto* -flto=thin
		else
			if [[ $(gcc-major-version) -lt 8 ]] ; then
				show_old_compiler_warning=1
			fi

			# Linking only works when using ld.gold when LTO is enabled
			append-ldflags -fuse-ld=gold
		fi

		if [[ -n "${show_old_compiler_warning}" ]] ; then
			# Checking compiler's major version uses CC variable. Because we allow
			# user to control used compiler via USE=clang flag, we cannot use
			# initial value. So this is the earliest stage where we can do this check
			# because pkg_pretend is not called in the main phase function sequence
			# environment saving is not guaranteed so we don't know if we will have
			# correct compiler until now.
			ewarn ""
			ewarn "USE=lto requires up-to-date compiler (>=gcc-8 or >=clang-7)."
			ewarn "You are on your own -- expect build failures. Don't file bugs using that unsupported configuration!"
			ewarn ""
			sleep 5
		fi
	else
		# Avoid auto-magic on linker
		if ! use clang ; then
			filter-flags -flto* -fuse-linker-plugin
		fi
	fi

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	#
	# FTL_JIT requires llvm
	#
	# opengl needs to be explicetly handled, bug #576634

	local opengl_enabled
	if use opengl || use gles2; then
		opengl_enabled=ON
	else
		opengl_enabled=OFF
	fi

	local mycmakeargs=(
		#-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build) # broken in 2.24.1
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_API_TESTS=$(usex test)
		-DENABLE_GTKDOC=$(usex doc)
		-DENABLE_GEOLOCATION=$(usex geolocation)
		$(cmake-utils_use_find_package gles2 OpenGLES2)
		-DENABLE_GLES2=$(usex gles2)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_WOFF2=ON
		-DENABLE_PLUGIN_PROCESS_GTK2=$(usex nsplugin)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEBGL=$(usex webgl)
		$(cmake-utils_use_find_package egl EGL)
		$(cmake-utils_use_find_package opengl OpenGL)
		-DENABLE_X11_TARGET=$(usex X)
		-DENABLE_OPENGL=${opengl_enabled}
		-DCMAKE_BUILD_TYPE=Release
		-DPORT=GTK
		${ruby_interpreter}
	)

	# Allow it to use GOLD when possible as it has all the magic to
	# detect when to use it and using gold for this concrete package has
	# multiple advantages and is also the upstream default, bug #585788
	if tc-ld-is-gold ; then
		mycmakeargs+=( -DUSE_LD_GOLD=ON )
	elif ! use clang ; then
		mycmakeargs+=( -DUSE_LD_GOLD=OFF )
	fi

	# Upstream only supports lld when using clang, and
	# ld breaks the default ulimit for open fds
	if use clang ; then
		mycmakeargs+=( -DCMAKE_LINKER=clang++ )
	fi

	# workaround silly broken arm64 assembler commit
	# https://trac.webkit.org/changeset/236589/webkit
	use arm64 && mycmakeargs+=( -DWTF_CPU_ARM64_CORTEXA53=OFF )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	# Prevents test failures on PaX systems
	pax-mark m $(list-paxables Programs/*[Tt]ests/*) # Programs/unittests/.libs/test*

	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	# Prevents crashes on PaX systems, bug #522808
	pax-mark m "${ED}usr/libexec/webkit2gtk-4.0/jsc" "${ED}usr/libexec/webkit2gtk-4.0/WebKitWebProcess"
	pax-mark m "${ED}usr/libexec/webkit2gtk-4.0/WebKitPluginProcess"
	use nsplugin && pax-mark m "${ED}usr/libexec/webkit2gtk-4.0/WebKitPluginProcess"2
}
