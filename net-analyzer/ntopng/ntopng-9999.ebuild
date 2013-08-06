# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="http://www.ntop.org/"

if [[ ${PV} == "9999" ]]
	then
		inherit subversion
		ESVN_REPO_URI="https://svn.ntop.org/svn/ntop/trunk/ntopng/"
		ESVN_REPO_URI="https://svn.ntop.org/svn/ntop/trunk/ntopng/"
		ESVN_BOOTSTRAP=""
	else
		SRC_URI="mirror://sourceforge/ntop/${PN}/${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-db/redis
${DEPEND}"

pkg_postinst()
{
	elog "ntopng default creadential are user='admin' password='admin'"
}

