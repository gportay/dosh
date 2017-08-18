#!/bin/sh
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

set -e

PREFIX="${PREFIX:-/usr/local}"

install -d "$DESTDIR$PREFIX/bin/"
install -m 755 dosh "$DESTDIR$PREFIX/bin/"

if [ -f dosh.1.gz ]; then
	install -d "$DESTDIR$PREFIX/share/man/man/1/"
	install -m 644 dosh.1.gz "$DESTDIR$PREFIX/share/man/man1/"
fi
