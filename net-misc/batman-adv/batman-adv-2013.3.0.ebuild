# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

CONFIG_CHECK="~!CONFIG_BATMAN_ADV"
MODULE_NAMES="${PN}(net:${S}:${S})"
BUILD_TARGETS="all"

inherit linux-mod

DESCRIPTION="Better approach to mobile Ad-Hoc networking on layer 2 kernel module"
HOMEPAGE="http://www.open-mesh.org/"
SRC_URI="http://downloads.open-mesh.org/batman/stable/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug bla"

DEPEND=""
RDEPEND="net-misc/batctl"

src_compile() {
	BUILD_PARAMS="CONFIG_BATMAN_ADV_DEBUG=$(use debug && echo y || echo n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_BLA=$(use bla && echo y || echo n)"
	export BUILD_PARAMS
	export KERNELPATH="${KERNEL_DIR}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	dodoc README CHANGELOG
	newconfd "${FILESDIR}/batman-adv.conf" batman-adv
	newinitd "${FILESDIR}/batman-adv.init" batman-adv
}
