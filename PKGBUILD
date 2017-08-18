# Maintainer: Gaël PORTAY <gael.portay@savoirfairelinux.com>

pkgname=dosh
pkgver=master
pkgrel=1
pkgdesc='Docker shell'
arch=('any')
url='https://github.com/gazoo74/dosh'
license=('MIT')
depends=('docker')
makedepends=('asciidoc')
source=('https://github.com/gazoo74/dosh/archive/master.tar.gz')

pkgver() {
	cd "$srcdir/dosh-master"
	printf "$(./dosh --version)r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "$srcdir/dosh-master"

	make doc
}

package() {
	cd "$srcdir/dosh-master"

	install -d "$pkgdir/usr/bin/"
	install -m 755 dosh "$pkgdir/usr/bin/"
	install -d "$pkgdir/usr/share/man/man1/"
	install -m 644 dosh.1.gz "$pkgdir/usr/share/man/man1/"
	install -d "$pkgdir/usr/share/bash-completion/completions"
	install -m 644 dosh "$pkgdir/usr/share/bash-completion/completions"
}
