# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base

DESCRIPTION="Leverage the OpenPGP web of trust for OpenSSH and Web authentication"
HOMEPAGE="http://web.monkeysphere.info/"
SRC_URI="http://archive.${PN}.info/debian/pool/${PN}/${PN::1}/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
app-crypt/gnupg
dev-perl/Crypt-OpenSSL-RSA
dev-perl/Digest-SHA1
app-misc/lockfile-progs"

src_prepare()
{
	sed -i "s#share/doc/monkeysphere#share/doc/${PF}#" Makefile
}

pkg_setup()
{
	ebegin "Creating named group and user"
	enewgroup monkeysphere
	enewuser monkeysphere -1 /bin/sh /var/lib/monkeysphere monkeysphere
	fowners root:root /var/lib/monkeysphere
	fperms 751 /var/lib/monkeysphere
	eend ${?}
}

DOCS=(README Changelog COPYING)
