# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LokiNET is an anonymous, decentralized and IP based overlay network that aims to be low-latency, high bandwidth and resistant to Sybil attacks."
HOMEPAGE="https://lokinet.org"

PKG_TB="${PN}-v${PV}.tar.xz"
SRC_URI="https://github.com/oxen-io/lokinet/releases/download/v${PV}/${PKG_TB}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm64 ~arm ~mips ~mips64 ~ppc64"
IUSE="cpu_flags_x86_avx2 coverage daemon debug embedded hive jemalloc liblokinet netns shadow testnet test"

DEPEND="dev-vcs/git
    dev-util/cmake
    >=dev-libs/libuv-1.27
    dev-libs/openssl
    net-misc/curl
    sys-libs/libunwind
    net-dns/unbound
    net-libs/oxenmq
    virtual/libcrypt
    dev-db/sqlite:3
    acct-user/lokinet
    acct-group/lokinet"

RDEPEND="${DEPEND}"

src_unpack() {
    unpack ${PKG_TB}
    # Respect Gentoo conventions
    mv "${PN}-v${PV}" "${PN}-${PV}"||die
}

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
        -DWITH_BOOTSTRAP=ON
        -DWITH_SETCAP=OFF
        -DLOKINET_VERSIONTAG="v0.9.9"
        ### This will be fixed later when lokinet devs ###
        ### Will be updating the ipv6 compare with arrays ###
        ### in c++20 it becomes a deprecated feature ###
        -DCMAKE_CXX_FLAGS="-Wno-array-compare"
    )

    cmake_src_configure
}

src_install() {
    if use daemon; then
        # OpenRC
        newconfd "${FILESDIR}/lokinet.conf" lokinet
        newinitd "${FILESDIR}/lokinet.init" lokinet

        # systemd is not supported yet
    fi

    cmake_src_install
}
