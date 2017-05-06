#!/bin/sh
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

PREFIX ?= /usr/local

.PHONY: all
all: doc
	@eval $$(cat /etc/os*release); echo $$NAME

.PHONY: doc
doc: dsh.1.gz dmake.1.gz docker-clean.1.gz docker-archive.1.gz

.PHONY: install
install:
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 755 dsh dmake $(DESTDIR)$(PREFIX)/bin/
	install -m 755 docker-clean docker-archive $(DESTDIR)$(PREFIX)/bin/
	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
	install -m 644 dsh.1.gz dmake.1.gz docker-clean.1.gz \
	               docker-archive.1.gz \
	           $(DESTDIR)$(PREFIX)/share/man/man1/
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		install -m 644 bash-completion/dsh \
		               bash-completion/dmake \
		               bash-completion/docker-clean \
		               bash-completion/docker-archive \
		               $(DESTDIR)$$completionsdir/; \
	fi

.PHONY: tests
tests:
	@./tests.sh

.PHONY: check
check: dsh dmake docker-clean docker-archive
	shellcheck $^

.PHONY: clean
clean:
	rm -f dsh.1.gz dmake.1.gz docker-clean.1.gz docker-archive.1.gz

%.1: %.1.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $^ >$@

