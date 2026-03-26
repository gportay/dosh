#!/usr/bin/env -S DOSH_DOCKERFILE=docker/pkg/Dockerfile dosh --no-doshrc
set -e
makepkg --force --skipchecksums "$@"
shellcheck --shell=bash --exclude=SC2034,SC2154,SC2164 PKGBUILD*
namcap PKGBUILD* *.pkg.tar*
