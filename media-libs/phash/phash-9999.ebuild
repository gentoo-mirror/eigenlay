# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake

DESCRIPTION="pHash open source perceptual hash library"
HOMEPAGE="https://www.phash.org/"
EGIT_REPO_URI="https://github.com/aetilius/pHash.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	media-libs/cimg
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/tiff"

multilib_src_configure()
{
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)
	cmake_src_configure
}
