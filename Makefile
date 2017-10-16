#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

PREFIX ?= /usr/local

.PHONY: all
all:
	@eval $$(cat /etc/os*release); echo $$NAME

.PHONY: doc
doc: dosh.1.gz

.PHONY: install
install:
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 755 dosh $(DESTDIR)$(PREFIX)/bin/
	install -d $(DESTDIR)$(PREFIX)/share/dosh/examples/
	install -m 644 examples/profile examples/dot-profile \
	           $(DESTDIR)$(PREFIX)/share/dosh/examples/

.PHONY: install-profile
install-profile:
	install -d $(DESTDIR)/etc/profile.d
	install -m 644 examples/profile $(DESTDIR)/etc/profile.d/dosh.sh

.PHONY: install-dot-profile
install-dot-profile:
	cat >>~/.profile examples/dot-profile

.PHONY: install-doc
install-doc:
	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
	install -m 644 dosh.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/

.PHONY: install-bash-completion
install-bash-completion:
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		install -m 644 bash-completion $(DESTDIR)$$completionsdir/dosh; \
	fi

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dosh
	rm -f $(DESTDIR)/etc/profile.d/dosh.sh
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/dosh.1.gz
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		rm -f $(DESTDIR)$$completionsdir/dosh; \
	fi

.PHONY: tests
tests:
	@./tests.sh

.PHONY: check
check: dosh
	shellcheck --exclude=SC1091 $^

.PHONY: clean
clean:
	rm -f dosh.1.gz
	rm -f PKGBUILD.aur *.tar.gz src/*.tar.gz *.pkg.tar.xz \
	   -R src/dosh-*/ pkg/dosh/

.PHONY: aur
aur: PKGBUILD.aur
	makepkg --force --syncdeps -p $^

PKGBUILD.aur: PKGBUILD
	cp $< $@.tmp
	makepkg --nobuild --nodeps --skipinteg -p $@.tmp
	md5sum="$$(makepkg --geninteg -p $@.tmp)"; \
	sed -e "/pkgver()/,/^$$/d" \
	    -e "/source=/a$$md5sum" \
	    -i $@.tmp
	mv $@.tmp $@

%.1: %.1.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $^ >$@

