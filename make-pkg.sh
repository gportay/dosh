#!/usr/bin/env -S DOSH_DOCKERFILE=Dockerfile.pkg dosh
set -e
makepkg --force --skipchecksums "$@"
shellcheck --shell=bash --exclude=SC2034,SC2154,SC2164 PKGBUILD
namcap PKGBUILD* *.pkg.tar*
