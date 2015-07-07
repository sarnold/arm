# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ETYPE="sources"
#K_WANT_GENPATCHES="base extras"
#K_GENPATCHES_VER="7"
#UNIPATCH_STRICTORDER="1"
K_DEBLOB_AVAILABLE="1"
K_NOUSEPR="1"

# without gentoo patches there is no security...
K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version
detect_arch

inherit versionator
MY_PR="bone${PR/r/}"
EXTRAVERSION="-${MY_PR}"

BONE_PATCH="patch-${KV_MAJOR}.${KV_MINOR}-${MY_PR}.diff.gz"
BONE_URI="https://rcn-ee.com/deb/sid-armhf/v${OKV}-${MY_PR}/${BONE_PATCH}"
UNIPATCH_LIST="${DISTDIR}/${BONE_PATCH} ${UNIPATCH_LIST}"

KEYWORDS="~arm"
HOMEPAGE="https://eewiki.net/display/linuxonarm/BeagleBone+Black"
IUSE="deblob"

##unset UNIPATCH_LIST_GENPATCHES UNIPATCH_LIST_DEFAULT

DESCRIPTION="Full sources ${KV_MAJOR}.${KV_MINOR} kernel plus BeagleBone patches"
SRC_URI="
	${KERNEL_URI}
	${BONE_URI}
	${ARCH_URI}
	"
## TODO: test gentoo patches when updated

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
