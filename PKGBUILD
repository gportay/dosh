# Maintainer: Gaël PORTAY <gael.portay@savoirfairelinux.com>

pkgname=dosh
pkgver=1.3.1.a
pkgrel=1
pkgdesc='Docker shell'
arch=('any')
url="https://github.com/gportay/$pkgname"
license=('MIT')
depends=('docker')
makedepends=('asciidoctor')
source=("https://github.com/gportay/$pkgname/archive/$pkgver.tar.gz")
md5sums=('3e4a0a99bd9faa6b40c4a71b526e8b53')

build() {
	cd "$srcdir/$pkgname-$pkgver"

	make doc
}

package() {
	cd "$srcdir/$pkgname-$pkgver"

	install -d "$pkgdir/usr/bin/"
	install -m 755 dosh "$pkgdir/usr/bin/"
	install -d "$pkgdir/usr/share/man/man1/"
	install -m 644 dosh.1.gz "$pkgdir/usr/share/man/man1/"
	install -d "$pkgdir/usr/share/bash-completion/completions"
	install -m 644 bash-completion "$pkgdir/usr/share/bash-completion/completions/dosh"
}
