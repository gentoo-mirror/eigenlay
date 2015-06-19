# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A loop-free distance-vector routing protocol"
HOMEPAGE="http://www.pps.univ-paris-diderot.fr/~jch/software/babel/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

if [[ ${PV} == "9999" ]]
	then
		inherit git-2
		EGIT_REPO_URI="git://git.wifi.pps.jussieu.fr/${PN}"
	else
		SRC_URI="http://www.pps.univ-paris-diderot.fr/~jch/software/files/${P}.tar.gz"
		RESTRICT="mirror"
fi

src_compile()
{
	emake PREFIX=/usr "CDEBUGFLAGS=${CFLAGS}" all || die "build failed"
}

src_install()
{
	exeinto /usr/sbin
	doexe babeld || die "install failed"

	newinitd "${FILESDIR}/babeld.init" babeld

	newconfd "${FILESDIR}/babeld.confd" babeld

	dodoc CHANGES README || die "dodoc failed"
	mv ${PN}.man ${PN}.8
	doman ${PN}.8 || die "doman failed"

	dodir /etc/babeld
	keepdir /etc/babeld
	insinto /etc/babeld ; doins "${FILESDIR}/${PN}.conf"

	keepdir /var/run/babeld/
	keepdir /var/log/babeld/
}
