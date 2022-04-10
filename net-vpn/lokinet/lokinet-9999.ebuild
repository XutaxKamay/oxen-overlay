# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Lokinet is an anonymous, decentralized and IP based overlay network that aims to be low-latency, high bandwidth and resistant to Sybil attacks."
HOMEPAGE="https://lokinet.org"

# latest stable (0.9.8) doesn't build because oxen-encoding is conflicting with older declarations in oxenmq ...
#PKG_TB="${PN}-v${PV}.tar.xz"
#SRC_URI="https://github.com/oxen-io/lokinet/releases/download/v${PV}/${PKG_TB}"
EGIT_REPO_URI='https://github.com/oxen-io/lokinet'

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm64 ~arm ~mips ~mips64 ~ppc64"
IUSE="cpu_flags_x86_avx2 bootstrap coverage debug embedded hive jemalloc liblokinet netns setcap shadow testnet test"

DEPEND="dev-vcs/git
	dev-util/cmake
	>=dev-libs/libuv-1.27
	bootstrap? ( dev-libs/openssl net-misc/curl )
	sys-libs/libunwind
	net-dns/unbound
	net-libs/oxenmq
	dev-db/sqlite:3"

RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DWARNINGS_AS_ERRORS=ON
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DBUILD_SHARED_LIBS=ON
		-DUSE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DUSE_NETNS=$(usex netns ON OFF)
		-DEMBEDDED_CFG=$(usex embedded ON OFF)
		-DBUILD_LIBLOKINET=$(usex liblokinet ON OFF)
		-DSHADOW=$(usex shadow ON OFF)
		-DUSE_JEMALLOC=$(usex jemalloc ON OFF)
		-DTESTNET=$(usex testnet ON OFF)
		-DWITH_COVERAGE=$(usex coverage ON OFF)
		-DWITH_TESTS=$(usex test ON OFF)
		-DWITH_HIVE=$(usex hive ON OFF)
		-DWITH_BOOTSTRAP=$(usex bootstrap ON OFF)
		-DWITH_SETCAP=$(usex setcap ON OFF)
	)

	cmake_src_configure
}
