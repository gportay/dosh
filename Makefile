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

.PHONY: install-bash-completion
install-bash-completion:
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		for bash in dsh dmake docker-clean docker-archive; do \
			install -m 644 bash-completion/$$bash \
			        $(DESTDIR)$$completionsdir/; \
		done; \
	fi

.PHONY: uninstall
uninstall:
	for bin in dsh dmake docker-clean docker-archive; do \
		rm -f $(DESTDIR)$(PREFIX)/bin/$$bin; \
	done
	for man in dsh.1.gz dmake.1.gz docker-clean.1.gz docker-archive.1.gz; do \
		rm -f $(DESTDIR)$(PREFIX)/share/man/man1/$$man; \
	done
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		for bash in dsh dmake docker-clean docker-archive; do \
			rm -f $(DESTDIR)$$completionsdir/$$bash; \
		done; \
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

