Name:           dosh
Version:        6
Release:        1%{?dist}
Summary:        Run a user shell in a container with cwd bind mounted.

License:        Unlicense
URL:            https://github.com/gportay/%{name}
Source0:        https://github.com/gportay/%{name}/archive/%{version}.tar.gz

BuildRequires:  make
BuildRequires:  shellcheck
Requires:       bash

%description
dosh(1) is an sh-compatible frontend for docker that runs commands in a new
container; using the current user, with cwd bind mounted.


%global debug_package %{nil}

%prep
%setup -q


%check
make check


%install
%make_install PREFIX=/usr


%files
%license LICENSE
%doc README.md
%{_bindir}/dosh
%{_datadir}/dosh/support/cqfd
%{_datadir}/dosh/support/doshx
%{_datadir}/dosh/support/dot-profile
%{_datadir}/dosh/support/posh
%{_datadir}/dosh/support/profile
%{_datadir}/dosh/support/zdosh


%changelog
* Fri Jun 27 2025 gportay
- Initial release.
