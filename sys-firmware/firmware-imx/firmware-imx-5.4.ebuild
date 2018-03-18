# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Freescale IMX firmware (VPU, SDMA)"
HOMEPAGE="http://homepage_to_some_wiki_about_this_stuff"
SRC_URI="http://repository.timesys.com/buildsources/f/${PN}/${P}/${P}.bin"
LICENSE="freescale"
SLOT="0"
KEYWORDS="~arm"

src_unpack() {
    sh "${DISTDIR}"/${A} --auto-accept
}

src_install() {
        # Stuff below taken from the recipe of the fsl-community-bsp
        install -d ${D}/lib/firmware/imx
        cp -rfv firmware/* ${D}/lib/firmware/imx/
        find ${D}/lib/firmware -type f -exec chmod 644 '{}' ';'

        # Remove files not going to be installed
        find ${D}/lib/firmware/ -name Android.mk -exec rm '{}' ';'
}
