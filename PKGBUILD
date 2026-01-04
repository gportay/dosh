# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=(dosh
	 dosh-linux-platforms
	 dosh-posh
	 dosh-cqfd)
pkgver=8
pkgrel=1
pkgdesc='Docker shell'
arch=(any)
url=https://github.com/gportay/dosh
license=(LGPL-2.1-or-later)
depends=(bash)
makedepends=(asciidoctor bash-completion)
checkdepends=(shellcheck)
source=("dosh-$pkgver.tar.gz::https://github.com/gportay/dosh/archive/$pkgver.tar.gz"
	"bash-completion-cqfd::https://raw.githubusercontent.com/savoirfairelinux/cqfd/v5.7.0/bash-completion")
sha256sums=(SKIP
            4af081815df72cde10579b085133f35734221680e3118883980cefe5d853bbb3)
validpgpkeys=(8F3491E60E62695ED780AC672FA122CA0501CA71)
changelog=CHANGELOG.md

build() {
	cd "dosh-$pkgver"
	make cqfd.1.gz cqfdrc.5.gz dosh.1.gz
}

check() {
	cd "dosh-$pkgver"
	make -k check
}

package_dosh() {
	depends+=(docker)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install install-doc install-bash-completion install-docker-cli-plugin
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/dosh/LICENSE"
}

package_dosh-linux-platforms() {
	pkgdesc='Docker shell for linux platforms'
	depends+=(dosh)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install-linux-platforms
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/dosh-linux-platforms/LICENSE"
}

package_dosh-posh() {
	pkgdesc='Podman shell'
	depends+=(dosh podman)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install-posh
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/dosh-posh/LICENSE"
}

package_dosh-cqfd() {
	pkgdesc='Wrap commands in controlled Docker containers using dosh'
	depends+=(dosh)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install-cqfd install-docker-cli-plugin-cqfd
	install -D -m 644 "$startdir/bash-completion-cqfd" "$pkgdir$completionsdir/cqfd"
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/dosh-cqfd/LICENSE"
}
