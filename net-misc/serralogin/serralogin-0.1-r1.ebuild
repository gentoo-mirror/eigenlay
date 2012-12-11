# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Serra UniPi Autologin Daemon"
HOMEPAGE="http://www.eigenlab.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/mechanize"

src_install()
{
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	exeinto /usr/sbin
	doexe "${FILESDIR}/${PN}-daemon" || die "install failed"

	dodir /etc/serralogin
	keepdir /etc/serralogin

	insinto /etc/serralogin
	doins "${FILESDIR}/loginlist.example"

	newconfd "${FILESDIR}/${PN}.conf" ${PN}.example
}
