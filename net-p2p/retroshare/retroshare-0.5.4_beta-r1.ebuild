# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib qt4-r2 versionator

MY_PN="RetroShare"
MY_PV="v$(get_version_component_range 1-3)"
if [[ "$(get_version_component_range 4)" == "alpha" ]] ; then
	MY_PV="${MY_PV}a"
elif [[ "$(get_version_component_range 4)" == "beta" ]] ; then
	MY_PV="${MY_PV}b"
fi
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli X links-cloud voip"

RDEPEND="
	dev-libs/libgpg-error
	gnome-base/libgnome-keyring
	net-libs/libupnp
	x11-libs/qt-core:4
	X? (
		x11-libs/libXScrnSaver
		x11-libs/qt-gui:4
		x11-libs/qt-opengl:4
	)
	voip? (
		   media-libs/speex
		   x11-libs/qt-mobility[multimedia]
		   x11-libs/qt-multimedia
	)"
DEPEND="${RDEPEND}"

#TODO add the voip X requirement
REQUIRED_USE="|| ( cli X ) links-cloud? ( X ) voip? ( X )"

S="${WORKDIR}/trunk"

src_prepare() {
	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use X && rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
	use links-cloud && rs_src_dirs="${rs_src_dirs} plugins/LinksCloud"
	if use voip ; then
		rs_src_dirs="${rs_src_dirs} plugins/VOIP"
		echo "QT += multimedia mobility" >> "plugins/VOIP/VOIP.pro"
	fi

	for dir in ${rs_src_dirs} ; do
		cd "${S}/${dir}"
		eqmake4
	done
}

src_compile() {
	for dir in ${rs_src_dirs} ; do
		einfo "entering ${dir} ..."
		cd "${S}/${dir}"
		emake
	done
}

src_install() {
	use cli && dobin retroshare-nogui/src/retroshare-nogui
	use X && dobin retroshare-gui/src/RetroShare

	extension_dir="/usr/$(get_libdir)/retroshare/extensions/"
	if use links-cloud ; then
		insinto ${extension_dir}
		doins "${S}/plugins/LinksCloud/*.so*"
	fi
	if use voip ; then
		insinto ${extension_dir}
		doins "${S}/plugins/VOIP/*.so*"
	fi

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins "${S}/libbitdht/src/bitdht/bdboot.txt"
}

pkg_postinst() {
	use X && einfo "The GUI executable name is: RetroShare"
	use cli && einfo "The console executable name is: retroshare-cli"
	elog "$(shasum ${extension_dir}/*.so)"
}
