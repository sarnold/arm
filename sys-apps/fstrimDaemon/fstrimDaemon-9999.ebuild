# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

EGIT_REPO_URI="https://github.com/dobek/fstrimDaemon.git"

inherit git-2

DESCRIPTION="Shell script daemon for fstrim to maintain ssd drive performance"
HOMEPAGE="https://github.com/dobek/fstrimDaemon"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="systemd"

RDEPEND="sys-apps/util-linux"

DEPEND="${RDEPEND}"

src_compile() {
	:
}

src_install() {
	dosbin usr/sbin/fstrimDaemon.sh
	dodoc README.md
	if ! use systemd ; then
		doinitd etc/init.d/fstrimDaemon
		doconfd etc/conf.d/fstrimDaemon
	else
		systemd_dounit usr/lib/systemd/system/fstrimDaemon.service
	fi
}

