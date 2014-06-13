# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator

CKV=$(get_version_component_range 1-3)
BONE_RELEASE=$(get_version_component_range 4-)
GITREV="5b3373356a7c"

ETYPE="sources"
K_SECURITY_UNSUPPORTED=1

inherit kernel-2 eutils
detect_version

DESCRIPTION="Kernel for Beaglebone (am33x) using RCN patches, etc"
HOMEPAGE="https://github.com/RobertCNelson/linux-dev"
PATCHSET_NAME="${PN/-*}-patches-${PV}.tar.gz"
PATCHSET_URI="https://github.com/RobertCNelson/linux-dev/archive/3.8.13-bone43.tar.gz -> $PATCHSET_NAME"
FIRMWARE_NAME="am335x-pm-firmware.bin"
FIRMWARE_GITREV="750362868d914702086187096ec2c67b68eac101"
FIRMWARE_URI="http://arago-project.org/git/projects/?p=am33x-cm3.git;a=blob_plain;f=bin/am335x-pm-firmware.bin;hb=${FIRMWARE_GITREV}"
SRC_URI="${KERNEL_URI} ${PATCHSET_URI} ${FIRMWARE_URI}"
KEYWORDS="~arm"

KV_FULL="${OKV}-bone${BONE_RELEASE}"
[[ -n "${PR//r0}" ]] && KV_FULL="${KV_FULL}-${PR}"
S="${WORKDIR}"/linux-"${KV_FULL}"

# from patch.sh
PATCHSET="dma rtc pinctrl cpufreq adc i2c da8xx-fb pwm mmc crypto 6lowpan capebus arm omap omap_sakoman omap_beagle_expansion omap_beagle omap_panda net drm not-capebus pru usb PG2 reboot iio w1 gpmc mxt ssd130x build hdmi audio resetctrl camera resources pmic pps leds capes proto fixes saucy machinekit sgx"
# need to exclude some from the list (from patch.sh)
patch_excludes() {
        local retVal=$1
        local pattern=$2
        case $pattern in
                "build")
                        eval $retVal="'0001-* 0002-* 0003-*'";;
                "resources")
                        eval $retVal="'0022-* 0023-*'";;
                *)
                        eval $retVal="";;
        esac
}

src_unpack() {
        unpack ${PATCHSET_NAME}
        kernel-2_src_unpack
}

src_prepare() {
        # directory name is based on github download
        local patchesdir="${WORKDIR}/RobertCNelson-linux-dev-${GITREV:0:7}"
        for ps in $PATCHSET; do
                einfo "Patchset: $ps"
                patch_excludes exclude $ps
                EPATCH_SOURCE="$patchesdir/patches/${ps}" EPATCH_OPTS="-p1" \
                                EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" \
                                EPATCH_EXCLUDE=$exclude epatch
        done

        cp "$patchesdir/patches/defconfig" "${S}/.config"
        cp "${DISTDIR}/${FIRMWARE_NAME};hb=${FIRMWARE_GITREV}" "${S}/firmware/${FIRMWARE_NAME}"
	elog "A copy of the latest RCN defconfig has been installed as .config"
	elog "in the kernel source dir."

        # replicate fixup patch from Calculus
        epatch "${FILESDIR}"/fix-db.txt-whitespace.patch

	# apply lkml patch for ncurses link issue (from jlec)
	epatch "${FILESDIR}"/dso-link-change.patch
}
