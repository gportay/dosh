.. SPDX-License-Identifier: LGPL-2.1-or-later

Building
========

Documentation
-------------

Build the documentation using *make(1)*:

::

	$ make doc
	make -C doc html
	Running Sphinx v7.2.6
	making output directory... done
	building [mo]: targets for 0 po files that are out of date
	writing output...
	building [html]: targets for 12 source files that are out of date
	updating environment: [new config] 12 added, 0 changed, 0 removed
	reading sources... [100%] tuning
	looking for now-outdated files... none found
	pickling environment... done
	checking consistency... done
	preparing documents... done
	copying assets... copying static files... done
	copying extra files... done
	done
	writing output... [100%] tuning
	generating indices... genindex done
	writing additional pages... search done
	dumping search index in English (code: en)... done
	dumping object inventory... done
	build succeeded.
	
	The HTML pages are in build/html.

Manual pages
------------

Build the manual pages using *make(1)*:

::

	$ make man
	asciidoctor -b manpage -o cqfd.1 support/cqfd.1.adoc
	gzip -c cqfd.1 >cqfd.1.gz
	asciidoctor -b manpage -o cqfdrc.5 support/cqfdrc.5.adoc
	gzip -c cqfdrc.5 >cqfdrc.5.gz
	asciidoctor -b manpage -o dosh.1 dosh.1.adoc
	gzip -c dosh.1 >dosh.1.gz
	rm cqfd.1 dosh.1 cqfdrc.5
