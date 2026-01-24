# Copyright (c) 2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
FROM debian:12

# https://github.com/moby/moby/issues/4032
ENV DPKG_FRONTEND=noninteractive

# https://docs.yoctoproject.org/5.0.15/ref-manual/system-requirements.html#ubuntu-and-debian
RUN apt -y update && apt -y install build-essential chrpath cpio debianutils diffstat file gawk gcc git iputils-ping libacl1 liblz4-tool locales python3 python3-git python3-jinja2 python3-pexpect python3-pip python3-subunit socat texinfo unzip wget xz-utils zstd

# https://github.com/buildroot/buildroot/blob/2564268f996dfb94ea2f0d1f776208bec63f6312/support/docker/Dockerfile#L27-L29
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && /usr/sbin/locale-gen

# https://kas.readthedocs.io/en/4.5/userguide/getting-started.html#dependencies-installation
RUN apt -y update && apt -y install python3-newt
RUN pip install --break-system-packages --no-cache-dir --upgrade pip && pip install --break-system-packages kas==4.5

# https://github.com/moby/moby/issues/4032
ENV DPKG_FRONTEND=
