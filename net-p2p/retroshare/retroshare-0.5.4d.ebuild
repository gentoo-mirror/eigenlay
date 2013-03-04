# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib qt4-r2 versionator

MY_PN="RetroShare"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli X links-cloud voip"

RDEPEND="
	dev-libs/libgpg-error
	gnome-base/libgnome-keyring
	net-libs/libupnp
	dev-qt/qtcore:4
	X? (
		x11-libs/libXScrnSaver
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	voip? (
		   media-libs/speex
		   dev-qt/qt-mobility[multimedia]
		   dev-qt/qtmultimedia
	)"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( cli X ) links-cloud? ( X ) voip? ( X )"

S="${WORKDIR}/trunk"

src_prepare()
{
	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use X && rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
	use links-cloud && rs_src_dirs="${rs_src_dirs} plugins/LinksCloud"

	use voip &&
	{
		rs_src_dirs="${rs_src_dirs} plugins/VOIP"
		echo "QT += multimedia mobility" >> "plugins/VOIP/VOIP.pro"
	}

	for dir in ${rs_src_dirs}
	do
		cd "${S}/${dir}"
		eqmake4
	done
}

src_compile()
{
	for dir in ${rs_src_dirs}
	do
		einfo "entering ${dir} ..."
		cd "${S}/${dir}"
		emake
	done
}

src_install()
{
	use cli && dobin retroshare-nogui/src/retroshare-nogui

	use X &&
	{
		dobin retroshare-gui/src/RetroShare
		newicon -s 32 retroshare-gui/src/gui/images/retrosharelogo32.png \
			${PN}.png
		newicon -s 128 retroshare-gui/src/gui/images/retrosharelogo1.png \
			${PN}.png
		make_desktop_entry RetroShare RetroShare ${PN}

		extension_dir="/usr/$(get_libdir)/retroshare/extensions/"
		use links-cloud &&
		{
			insinto "${extension_dir}"
			doins "${S}"/plugins/LinksCloud/*.so*
		}
		use voip &&
		{
			insinto "${extension_dir}"
			doins "${S}"/plugins/VOIP/*.so*
		}
	}

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins "${S}/libbitdht/src/bitdht/bdboot.txt"
}

pkg_postinst()
{
	use X && einfo "The GUI executable name is: RetroShare"
	use cli && einfo "The console executable name is: retroshare-cli"
	use links-cloud || use voip &&
	{
		elog "Plugin hashes:"
		elog "$(shasum ${extension_dir}/*.so)"
	}

	einfo ""
	einfo "To update your DHT bootstrap peers run on your user shell replacing YOUR_SSL_ID"
	einfo "cp ${S}/libbitdht/src/bitdht/bdboot.txt ${HOME}/.retroshare/YOUR_SSL_ID/bdboot.txt"
}
