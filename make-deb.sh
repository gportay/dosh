#!/usr/bin/env -S DOSH_DOCKERFILE=docker/deb/Dockerfile parent=1 dosh --no-doshrc
set -e
dpkg-buildpackage -us -uc "$@"
lintian ../dosh*.dsc ../dosh*.deb
