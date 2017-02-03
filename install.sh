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
install -m 755 dsh "$DESTDIR$PREFIX/bin/"
