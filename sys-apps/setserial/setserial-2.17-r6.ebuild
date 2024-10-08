# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Configure your serial ports with it"
HOMEPAGE="http://setserial.sourceforge.net/"
SRC_URI="
	ftp://tsx-11.mit.edu/pub/linux/sources/sbin/${P}.tar.gz
	ftp://ftp.sunsite.org.uk/Mirrors/tsx-11.mit.edu/pub/linux/sources/sbin/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-spelling.patch
	"${FILESDIR}"/${P}-manpage-updates.patch
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-hayes-esp.patch
	"${FILESDIR}"/${P}-darwin.patch
	"${FILESDIR}"/${P}-implicit-int-clang16.patch
)

src_prepare() {
	default

	sed -i -e 's:configure.in:configure.ac:' Makefile.in || die

	# Clang 16
	eautoreconf
}

src_compile() {
	tc-export CC
	emake "${PN}"
}

src_install() {
	doman "${PN}.8"
	into /
	dobin "${PN}"

	insinto /etc
	doins serial.conf
	newinitd "${FILESDIR}"/serial-2.17-r4 serial

	einstalldocs
	docinto txt
	dodoc Documentation/*
}
