# cat /usr/local/ebuilds/sys-firmware/firmware-imx/firmware-imx-3.14.28-r0.ebuild

EAPI="5"

inherit eutils

DESCRIPTION="Freescale IMX firmware (VPU, SDMA)"
HOMEPAGE="http://homepage_to_some_wiki_about_this_stuff"
#SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${P}-1.1.0-beta.bin"
SRC_URI="http://repository.timesys.com/buildsources/f/${PN}/${P}-1.0.0/${P}-1.0.0.bin"
LICENSE="freescale"
SLOT="0"
KEYWORDS="~arm"

S="${WORKDIR}"/${P}-1.0.0

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
