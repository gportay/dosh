# Copyright (c) 2025-2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
FROM archlinux:base-devel
RUN pacman -Sy --noconfirm asciidoctor bash-completion git namcap shellcheck
CMD ["makepkg", "--force", "--skipchecksums"]
