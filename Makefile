#
# Copyright (c) 2017-2020,2023 Gaël PORTAY
#
# SPDX-License-Identifier: MIT
#

PREFIX ?= /usr/local

.PHONY: all
all:
	@eval $$(cat /etc/os*release); echo $$NAME

.PHONY: doc
doc: PATH:=$(CURDIR):$(PATH)
doc: SHELL=dosh
doc: dosh.1.gz

.PHONY: install-all
install-all: install install-doc install-bash-completion

.PHONY: install
install:
	install -D -m 755 dosh $(DESTDIR)$(PREFIX)/bin/dosh
	install -D -m 755 support/doshx $(DESTDIR)$(PREFIX)/share/dosh/support/doshx
	install -D -m 755 support/posh $(DESTDIR)$(PREFIX)/share/dosh/support/posh
	install -D -m 755 support/zdosh $(DESTDIR)$(PREFIX)/share/dosh/support/zdosh
	install -D -m 644 support/profile $(DESTDIR)$(PREFIX)/share/dosh/support/profile
	install -D -m 644 support/dot-profile $(DESTDIR)$(PREFIX)/share/dosh/support/dot-profile

.PHONY: install-profile
install-profile:
	install -D -m 644 support/profile $(DESTDIR)/etc/profile.d/dosh.sh

.PHONY: install-dot-profile
install-dot-profile:
	cat >>~/.profile support/dot-profile

.PHONY: install-doc
install-doc:
	install -D -m 644 dosh.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/dosh.1.gz

.PHONY: install-bash-completion
install-bash-completion:
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                             --variable=completionsdir \
	                             bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		install -D -m 644 bash-completion $(DESTDIR)$$completionsdir/dosh; \
	fi

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dosh
	rm -f $(DESTDIR)/etc/profile.d/dosh.sh
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/dosh.1.gz
	rm -Rf $(DESTDIR)$(PREFIX)/share/dosh/
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                             --variable=completionsdir \
	                             bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		rm -f $(DESTDIR)$$completionsdir/dosh; \
	fi

.PHONY: user-install-all
user-install-all: user-install user-install-doc user-install-bash-completion

user-install user-install-doc user-install-bash-completion user-uninstall:
user-%:
	$(MAKE) $* PREFIX=$$HOME/.local BASHCOMPLETIONSDIR=$$HOME/.local/share/bash-completion/completions

.PHONY: ci
ci: export EXIT_ON_ERROR = 1
ci: export DO_RMI_TESTS = 1
ci: export DOCKER_BUILDKIT ?= 0
ci: check coverage

DO_RMI_TESTS ?=
.PHONY: test tests
test tests: export DOCKER_BUILDKIT ?= 0
test tests:
	@DO_RMI_TESTS=$(DO_RMI_TESTS) ./tests.bash

.PHONY: check
check: dosh
	shellcheck --exclude=SC1090 --exclude=SC1091 $^

.PHONY: coverage
coverage:
	kcov $(CURDIR)/$@ --include-path=dosh $(CURDIR)/tests.bash

ifneq (,$(BUMP_VERSION))
.SILENT: bump
.PHONY: bump
bump: export GPG_TTY ?= $(shell tty)
bump:
	! git tag | grep "^$(BUMP_VERSION)$$"
	old="$$(bash dosh --version)"; \
	sed -e "/^VERSION=/s,$$old,$(BUMP_VERSION)," -i dosh; \
	sed -e "/^:man source:/s,$$old,$(BUMP_VERSION)," -i dosh.1.adoc; \
	sed -e "/^pkgver=/s,$$old,$(BUMP_VERSION)," -e "/^pkgrel=/s,=.*,=1," -i PKGBUILD
	git commit --gpg-sign dosh dosh.1.adoc PKGBUILD --patch --message "dosh: version $(BUMP_VERSION)"
	git tag --sign --annotate --message "dosh-$(BUMP_VERSION)" "$(BUMP_VERSION)"
else
.SILENT: bump-major
.PHONY: bump-major
bump-major:
	old="$$(bash dosh --version)"; \
	new="$$(($${old%.*}+1))"; \
	$(MAKE) bump "BUMP_VERSION=$$new"

.SILENT: bump-minor
.PHONY: bump-minor
bump-minor:
	old="$$(bash dosh --version)"; \
	if [ "$${old%.*}" = "$$old" ]; then old="$$old.0"; fi; \
	new="$${old%.*}.$$(($${old##*.}+1))"; \
	$(MAKE) bump "BUMP_VERSION=$$new"

.SILENT: bump
.PHONY: bump
bump: bump-major
endif

.PHONY: bump-PKGBUILD
bump-PKGBUILD: updpkgsums
	git commit PKGBUILD --patch --message "PKGBUILD: update release $$(bash dosh --version) checksum"

.PHONY: commit-check
commit-check:
	git rebase -i -x "$(MAKE) check && $(MAKE) tests"

.PHONY: clean
clean:
	rm -f dosh.1.gz
	rm -f PKGBUILD.tmp *.tar.gz src/*.tar.gz *.pkg.tar.xz \
	   -R src/dosh-*/ pkg/dosh-*/ dosh-git/
	rm -Rf coverage/

.PHONY: mrproper
mrproper: clean
	DO_CLEANUP=1 bash tests.bash

.PHONY: updpkgsums
updpkgsums:
	updpkgsums

.PHONY: aur
aur:
	makepkg --force --syncdeps

.PHONY: aur-git
aur-git: PKGBUILD.tmp
	makepkg --force --syncdeps -p $^

PKGBUILD.tmp: PKGBUILD-git
	cp $< $@

%.1: %.1.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $< >$@

