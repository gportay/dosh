# Copyright (c) 2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
FROM ubuntu:20.04

# https://github.com/moby/moby/issues/4032
ARG DEBIAN_FRONTEND=noninteractive

# https://docs.docker.com/engine/install/debian/#uninstall-old-versions
RUN apt-get update && apt-get install -y docker.io

# https://github.com/gportay/dosh/blob/master/tests.bash
RUN apt-get update && apt-get install -y sudo make fakeroot bash-completion zsh wget
RUN wget -O /etc/zsh/zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
USER nobody
WORKDIR /tmp
ENV USER=nobody
ENV HOME=/tmp
ENTRYPOINT ["/bin/echo","Hello, world!"]
