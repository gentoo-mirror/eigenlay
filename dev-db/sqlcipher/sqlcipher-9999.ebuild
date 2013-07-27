# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils versionator flag-o-matic

DESCRIPTION="Like SQLite but encrypted"
HOMEPAGE="http://sqlcipher.net/"

if [[ ${PV} == "9999" ]]
	then
		inherit git-2
		EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
fi

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="sqlcipher"

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}"

src_configure()
{
	append-cflags -DSQLITE_HAS_CODEC
	append-ldflags -lcrypto

	econf --enable-tempstore=yes
}
