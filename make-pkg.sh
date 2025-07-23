#!/usr/bin/env -S DOSH_DOCKERFILE=Dockerfile.pkg dosh
set -e
makepkg --force --skipchecksums "$@"
namcap PKGBUILD* *.pkg.tar*
