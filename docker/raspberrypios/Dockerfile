# Copyright (c) 2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
FROM --platform=linux/arm64 debian:bookworm

# https://github.com/moby/moby/issues/4032
ENV DPKG_FRONTEND=noninteractive

# https://archive.raspberrypi.com/debian/
COPY raspberrypi-archive-stable.gpg /etc/apt/trusted.gpg.d/raspberrypi-archive-stable.gpg
COPY raspi.list /etc/apt/sources.list.d/raspi.list
RUN apt-get update && apt-get upgrade -y

# https://github.com/moby/moby/issues/4032
ENV DPKG_FRONTEND=
