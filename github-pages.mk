#!/usr/bin/make -f
#
# The MIT License (MIT)
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# See: https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/

.PHONY: all
all: exec

.SILENT: Gemfile
Gemfile:
	echo "# GitHub Pages" >$@.tmp
	echo "source 'https://rubygems.org'" >>$@.tmp
	echo "gem 'github-pages', group: :jekyll_plugins" >>$@.tmp
	echo "group :jekyll_plugins do" >>$@.tmp
	echo "  gem 'jekyll-asciidoc'" >>$@.tmp
	echo "end" >>$@.tmp
	cat $@.tmp >>$@
	rm -f $@.tmp

_config.yml:
	echo "theme: jekyll-theme-cayman" >$@.tmp
	cat $@.tmp >>$@
	rm -f $@.tmp

.PHONY: exec
exec: bundle-exec

.PHONY: update
update: bundle-update

.SILENT: install
.PHONY: install
install:
	if ! which bundler >/dev/null 2>&1; then \
		gem install bundler; \
	fi

.PHONY: clean
clean:
	rm -Rf _site

bundle-install:
bundle-exec: _config.yml
bundle-exec: override BUNDLEFLAGS+=jekyll serve
bundle-update:
bundle-%: Gemfile
	bundle $* $(BUNDLEFLAGS)

