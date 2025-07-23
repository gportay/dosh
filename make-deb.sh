#!/usr/bin/env -S DOSH_DOCKERFILE=Dockerfile.deb home=1 dosh
set -e
dpkg-buildpackage -us -uc "$@"
lintian ../dosh*.deb
