# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="High-level zeromq-based message passing for network-based projects"
HOMEPAGE="https://oxen.io"

#PKG_TB="${PN}-v${PV}.tar.gz"
#SRC_URI="https://github.com/oxen-io/oxen-mq/archive/refs/tags/v${PV}/${PKG_TB}"
EGIT_REPO_URI='https://github.com/oxen-io/oxen-mq'

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm64 ~arm ~mips ~mips64 ~ppc64"
IUSE="debug static test"

DEPEND="dev-vcs/git
	dev-util/cmake
	>=dev-libs/libsodium-1.0.18
	net-libs/zeromq
	net-libs/cppzmq
	dev-libs/oxenc
	test? ( >=dev-cpp/catch-2 )"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/oxenmq-9999-cmake_catch2_test.patch
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DWARNINGS_AS_ERRORS=ON
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DOXENMQ_INSTALL_CPPZMQ=OFF
	)

	cmake_src_configure
}
