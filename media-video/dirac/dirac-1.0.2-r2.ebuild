# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Open Source video codec"
HOMEPAGE="http://dirac.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug doc cpu_flags_x86_mmx"

BDEPEND="
	doc? (
		app-text/doxygen
		virtual/latex-base
		media-gfx/graphviz
		>=app-text/texlive-core-2014
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.2-doc.patch
)

src_prepare() {
	default

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	export VARTEXFONTS="${T}/fonts"

	econf \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable debug) \
		$(use_enable doc)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		latexdir="${EPREFIX}/usr/share/doc/${PF}/programmers" \
		algodir="${EPREFIX}/usr/share/doc/${PF}/algorithm" \
		faqdir="${EPREFIX}/usr/share/doc/${PF}" \
		install

	find "${ED}" -name '*.la' -delete || die
	einstalldocs
}
