# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="babeld safe route sharing tool"
HOMEPAGE="http://www.eigenlab.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	net-misc/iputils
	sys-apps/iproute2
	net-misc/babeld
	"

src_install()
{
	newinitd "${FILESDIR}"/${PN}-daemon.init ${PN}

	exeinto /usr/sbin
	doexe ${FILESDIR}/${PN}-daemon || die "install failed"

	dodir /etc/babeld
	keepdir /etc/babeld

	insinto /etc/babeld
	doins "${FILESDIR}/${PN}-daemon.conf"
}
