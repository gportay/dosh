# Copyright (c) 2025-2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
FROM fedora:43
RUN dnf install -y asciidoctor bash-completion-devel git make pkgconf rpmdevtools rpmlint shellcheck
CMD ["rpmbuild", "--undefine=_disable_source_fetch", "--define='_dockerlibdir %{_exec_prefix}/lib/docker'", "-ba", "dosh.specs"]
