Name:           dosh
Version:        7
Release:        1%{?dist}
Summary:        Run a user shell in a container with cwd bind mounted.

License:        Unlicense
URL:            https://github.com/gportay/%{name}
Source0:        https://github.com/gportay/%{name}/archive/%{version}.tar.gz

BuildRequires:  asciidoctor
BuildRequires:  make
BuildRequires:  shellcheck
Requires:       bash

%description
dosh(1) is an sh-compatible frontend for docker that runs commands in a new
container; using the current user, with cwd bind mounted.


%global debug_package %{nil}

%package  docker-shell
Requires: docker
Summary:  Docker CLI plugin for dosh.

%description docker-shell
Docker CLI plugin for dosh.


%package  dosh-cqfd
Requires: dosh
Summary:  A tool to wrap commands in controlled Docker containers using dosh.

%description dosh-cqfd
A tool to wrap commands in controlled Docker containers using dosh.


%package  docker-cqfd
Requires: docker
Requires: dosh-cqfd
Summary:  Docker CLI plugin for cqfd.

%description docker-cqfd
Docker CLI plugin for cqfd.


%prep
%setup -q


%check
make check


%build
%make_build dosh.1.gz


%install
%make_install PREFIX=/usr DOCKERLIBDIR=%{_libdir}/docker install-all install-cqfd install-cli-plugin-sh install-cli-plugin-bash install-cli-plugin-zsh install-cli-plugin-cqfd


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


%files docker-shell
%{_libdir}/docker/cli-plugins/docker-bash
%{_libdir}/docker/cli-plugins/docker-sh
%{_libdir}/docker/cli-plugins/docker-shell
%{_libdir}/docker/cli-plugins/docker-zsh

%files dosh-cqfd
%{_bindir}/cqfd

%files docker-cqfd
%{_libdir}/docker/cli-plugins/docker-cqfd

%changelog
* Tue Jul 01 2025 gportay
- Initial release.
