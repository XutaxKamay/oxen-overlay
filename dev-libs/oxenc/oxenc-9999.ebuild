# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/oxen-io/oxen-encoding"
DESCRIPTION="Base 16/32/64 and Bittorrent Encoding/Decoding Header Only Library "
HOMEPAGE="https://oxen.io"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm ~mips ~mips64 ~ppc64"
IUSE="test"

DEPEND="test? ( >=dev-cpp/catch-2 )"

RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DOXENC_BUILD_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure
}
