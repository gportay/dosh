# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=(dosh docker-shell dosh-cqfd docker-cqfd)
pkgver=7
pkgrel=1
pkgdesc='Docker shell'
arch=('any')
url="https://github.com/gportay/$pkgname"
license=('LGPL')
depends=('docker')
makedepends=('asciidoctor')
checkdepends=('shellcheck')
source=("https://github.com/gportay/$pkgname/archive/$pkgver.tar.gz"
	"bash-completion-cqfd::https://raw.githubusercontent.com/savoirfairelinux/cqfd/v5.7.0/bash-completion")
sha256sums=('4739c3f8cf2385b867e3b9da561ca9c864447c870f0025fb8f32f0cdea5989dd'
            '4af081815df72cde10579b085133f35734221680e3118883980cefe5d853bbb3')
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
