.. SPDX-License-Identifier: LGPL-2.1-or-later

Building
========

Documentation
-------------

Build the documentation using *make(1)*:

::

	$ make html
	make -C docs/readthedocs html
	make: Entering directory '/home/gportay/src/dosh/docs/readthedocs'
	Running Sphinx v8.2.3
	loading translations [en]... done
	making output directory... done
	building [mo]: targets for 0 po files that are out of date
	writing output... 
	building [html]: targets for 12 source files that are out of date
	updating environment: [new config] 12 added, 0 changed, 0 removed
	reading sources... [  8%] building
	reading sources... [ 17%] contributing
	reading sources... [ 25%] copyright
	reading sources... [ 33%] cross-platform
	reading sources... [ 42%] index
	reading sources... [ 50%] install
	reading sources... [ 58%] interpreter
	reading sources... [ 67%] links
	reading sources... [ 75%] overview
	reading sources... [ 83%] podman
	reading sources... [ 92%] requirements
	reading sources... [100%] tuning
	
	looking for now-outdated files... none found
	pickling environment... done
	checking consistency... done
	preparing documents... done
	copying assets... 
	copying static files... 
	Writing evaluated template result to /home/gportay/src/dosh/docs/readthedocs/build/html/_static/language_data.js
	Writing evaluated template result to /home/gportay/src/dosh/docs/readthedocs/build/html/_static/basic.css
	Writing evaluated template result to /home/gportay/src/dosh/docs/readthedocs/build/html/_static/documentation_options.js
	Writing evaluated template result to /home/gportay/src/dosh/docs/readthedocs/build/html/_static/js/versions.js
	copying static files: done
	copying extra files... 
	copying extra files: done
	copying assets: done
	writing output... [  8%] building
	writing output... [ 17%] contributing
	writing output... [ 25%] copyright
	writing output... [ 33%] cross-platform
	writing output... [ 42%] index
	writing output... [ 50%] install
	writing output... [ 58%] interpreter
	writing output... [ 67%] links
	writing output... [ 75%] overview
	writing output... [ 83%] podman
	writing output... [ 92%] requirements
	writing output... [100%] tuning
	
	generating indices... genindex done
	writing additional pages... search done
	dumping search index in English (code: en)... done
	dumping object inventory... done
	build succeeded.
	
	The HTML pages are in build/html.
	make: Leaving directory '/home/gportay/src/dosh/docs/readthedocs'

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
