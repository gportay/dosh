# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=(dosh docker-shell dosh-cqfd docker-cqfd)
pkgver=6
pkgrel=1
pkgdesc='Docker shell'
arch=('any')
url="https://github.com/gportay/$pkgname"
license=('LGPL')
depends=('docker')
makedepends=('asciidoctor')
checkdepends=('shellcheck')
source=("https://github.com/gportay/$pkgname/archive/$pkgver.tar.gz"
	"bash-completion-cqfd::https://raw.githubusercontent.com/savoirfairelinux/cqfd/v5.4.0/bash-completion")
sha256sums=('915e275ca1314789a895504df4e149f0335b8749e2740da99009f71caaa46a38'
            'b231b48d37e72736302b2961ee2ebd392d48796aa4cdf5c84c73f87e5c1607b6')
validpgpkeys=('8F3491E60E62695ED780AC672FA122CA0501CA71')

build() {
	cd "$pkgname-$pkgver"
	make doc SHELL="/bin/sh"
}

check() {
	cd "$pkgname-$pkgver"
	make -k check
}

package_dosh() {
	optdepends+=(docker-shell)

	cd "$pkgname-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install install-doc install-bash-completion
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

package_docker-shell() {
	pkgdesc='Docker CLI plugin for dosh'
	rdepends=(dosh)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir/" PREFIX="/usr" install-cli-plugin
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

package_dosh-cqfd() {
	pkgdesc='A tool to wrap commands in controlled Docker containers using dosh'
	rdepends=(dosh)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir/" PREFIX="/usr" install-cqfd
	completionsdir="$(pkg-config --define-variable=prefix=/usr --variable=completionsdir bash-completion)"
	install -D -m 644 ${startdir}/bash-completion-cqfd "$pkgdir$completionsdir/cqfd"
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

package_docker-cqfd() {
	pkgdesc='Docker CLI plugin for cqfd'
	rdepends=(cqfd)

	cd "dosh-$pkgver"
	make DESTDIR="$pkgdir/" PREFIX="/usr" install-cli-plugin-cqfd
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
