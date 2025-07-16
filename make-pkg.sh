#!/usr/bin/env -S DOSH_DOCKERFILE=Dockerfile.pkg dosh
makepkg --force --skipchecksums "$@"
namcap PKGBUILD* *.pkg.tar*
