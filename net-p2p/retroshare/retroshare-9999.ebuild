# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib qt4-r2 versionator

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli X links-cloud voip gxs"

if [[ ${PV} == "9999" ]]
	then
		inherit subversion
		ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"
	else
		MY_PN="RetroShare"
		MY_P="${MY_PN}-v${PV}"
		SRC_URI="mirror://sourceforge/retroshare/${MY_P}.tar.gz"
		RESTRICT="mirror"
		S="${WORKDIR}/retroshare-0.5.4/src"
fi

RDEPEND="
	dev-libs/libgpg-error
	gnome-base/libgnome-keyring
	net-libs/libssh[server]
	net-libs/libupnp
	dev-libs/protobuf
	dev-db/sqlite
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
	)
	gxs? ( dev-db/sqlcipher )"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( cli X ) links-cloud? ( X ) voip? ( X )"

src_prepare()
{
	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src"

#	sed -i '/#define ENABLE_ENCRYPTED_DB/d' "${S}/libretroshare/src/util/retrodb.cc"

	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use X &&
	{
		rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
		# Patch code to enable empty passphrase
		sed -i -e 's/(ui\.password_input->text()\.length() < 3 || ui\.name_input->text()\.length() < 3 || genLoc\.length() < 3)/(ui.name_input->text().length() < 3 || genLoc.length() < 3)/' "${S}/retroshare-gui/src/gui/GenCertDialog.cpp" || die "Failed patching to disable empty password check"
	}
	use links-cloud && rs_src_dirs="${rs_src_dirs} plugins/LinksCloud"

	use voip &&
	{
		rs_src_dirs="${rs_src_dirs} plugins/VOIP"
		echo "QT += multimedia mobility" >> "plugins/VOIP/VOIP.pro"
	}

	use gxs &&
	{
		sed -i '1iCONFIG += gxs' "${S}/libretroshare/src/libretroshare.pro"
		sed -i '1iCONFIG += gxs' "${S}/retroshare-gui/src/retroshare-gui.pro"
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

	elog ""
	elog "To update your DHT bootstrap peers run the following command replacing YOUR_HOME and YOUR_SSL_ID with the correct values"
	elog "cp /usr/share/${PN}/bdboot.txt /YOUR_HOME/.retroshare/YOUR_SSL_ID/bdboot.txt"
}
