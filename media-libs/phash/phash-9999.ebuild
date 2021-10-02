# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake

DESCRIPTION="pHash open source perceptual hash library"
HOMEPAGE="https://www.phash.org/"
EGIT_REPO_URI="https://gitlab.com/g10h4ck/pHash.git"
EGIT_BRANCH="multilib-install"

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

src_prepare()
{
	cmake_src_prepare
}

src_configure()
{
	cmake_src_configure
}
