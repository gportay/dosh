# Copyright (c) 2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
FROM ghcr.io/homebrew/brew:7.0.12
ENV HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1
RUN brew install asciidoctor bash coreutils && chmod -R a+rwX /home/linuxbrew
USER root
RUN git config --system --add safe.directory '*'
USER linuxbrew
CMD ["brew", "install", "--build-bottle", "gportay/dosh/dosh"]
