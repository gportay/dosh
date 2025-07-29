Name:           dosh
Version:        7
Release:        1
Summary:        Run a user shell in a container with working directory bind mounted

License:        LGPL-2.1-or-later
URL:            https://github.com/gportay/%{name}
Source0:        https://github.com/gportay/%{name}/archive/%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  asciidoctor
BuildRequires:  make
BuildRequires:  shellcheck
BuildRequires:  pkgconfig(bash-completion)
Requires:       bash
Requires:       docker

%description
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%global debug_package %{nil}

%package  linux-amd64
Requires: dosh
Summary:  Docker shell for linux/amd64 platform

%description linux-amd64
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%package  linux-arm64
Requires: dosh
Summary:  Docker shell for linux/arm64 platform

%description linux-arm64
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%package  linux-arm
Requires: dosh
Summary:  Docker shell for linux/arm platform

%description linux-arm
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%package  linux-ppc64le
Requires: dosh
Summary:  Docker shell for linux/ppc64le platform

%description linux-ppc64le
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%package  linux-riscv64
Requires: dosh
Summary:  Docker shell for linux/riscv64 platform

%description linux-riscv64
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%package  linux-s390x
Requires: dosh
Summary:  Docker shell for linux/s390x platform

%description linux-s390x
dosh(1) is an sh-compatible front-end for docker that runs commands in a new
container; using the current user, with working directory bind mounted.


%package  docker-shell
Requires: docker
Summary:  Docker CLI plugin for dosh

%description docker-shell
Docker CLI plugin for dosh.


%package  cqfd
Requires: dosh
Summary:  Wrap commands in controlled Docker containers using dosh

%description cqfd
Wrap commands in controlled Docker containers using dosh.
cqfd provides a quick and convenient way to run commands in the current
directory, but within a Docker container defined in a per-project config file.


%package  docker-cqfd
Requires: docker
Requires: dosh-cqfd
Summary:  Docker CLI plugin for cqfd

%description docker-cqfd
Docker CLI plugin for cqfd.


%prep
%setup -q


%check
make check


%build
%make_build cqfd.1.gz cqfdrc.5.gz dosh.1.gz


%install
%make_install PREFIX=/usr DOCKERLIBDIR=%{_libdir}/docker install-all install-cqfd install-docker-cli-plugin-sh install-docker-cli-plugin-bash install-docker-cli-plugin-zsh install-docker-docker-cli-plugin-cqfd install-linux-amd64-dosh install-linux-arm64-dosh install-linux-arm-dosh install-linux-arm-v6-dosh install-linux-arm-v7-dosh install-linux-ppc64le-dosh install-linux-riscv64-dosh install-linux-s390x-dosh


%files
%license LICENSE
%doc README.md
%{_bindir}/dosh
%{_datadir}/bash-completion/completions/dosh
%{_datadir}/dosh/support/cqfd
%{_datadir}/dosh/support/doshx
%{_datadir}/dosh/support/dot-profile
%{_datadir}/dosh/support/posh
%{_datadir}/dosh/support/profile
%{_datadir}/dosh/support/zdosh
%{_datadir}/man/man1/dosh.1.gz


%files linux-amd64
%{_bindir}/linux-amd64-dosh


%files linux-arm64
%{_bindir}/linux-arm64-dosh


%files linux-arm
%{_bindir}/linux-arm-dosh
%{_bindir}/linux-arm-v6-dosh
%{_bindir}/linux-arm-v7-dosh


%files linux-ppc64le
%{_bindir}/linux-ppc64le-dosh


%files linux-riscv64
%{_bindir}/linux-riscv64-dosh


%files linux-s390x
%{_bindir}/linux-s390x-dosh


%files docker-shell
%{_libdir}/docker/cli-plugins/docker-bash
%{_libdir}/docker/cli-plugins/docker-sh
%{_libdir}/docker/cli-plugins/docker-shell
%{_libdir}/docker/cli-plugins/docker-zsh


%files cqfd
%{_bindir}/cqfd
%{_datadir}/man/man1/cqfd.1.gz
%{_datadir}/man/man5/cqfdrc.5.gz


%files docker-cqfd
%{_libdir}/docker/cli-plugins/docker-cqfd


%changelog
* Tue Jul 01 2025 Gaël PORTAY <gael.portay@gmail.com> - 7-1
- Initial release.
