# Docker Shell

## NAME

[dosh](dosh.1.adoc) - run a user shell in a container with pwd bind mounted

## DESCRIPTION

[dosh](dosh) runs the _command_ process in a container; using the current
_user_, with _pwd_ bind mounted.

## DOCUMENTATION

Build documentation using _build-doc.dosh_ *dosh(1)* script

	$ ./build-doc.dosh
	sha256:ced062433e33

Or using *make(1)* and _Makefile_

	$ make
	asciidoctor -b manpage -o dosh.1 dosh.1.adoc
	gzip -c dosh.1 >dosh.1.gz
	rm dosh.1

## INSTALL

Run the following command to install *dosh(1)*

	$ sudo ./install.sh

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo PREFIX=/opt/dosh ./install.sh

or

	$ DESTDIR=$PWD/pkg PREFIX=/usr ./install.sh

## LINKS

Check for [man-pages](dosh.1.adoc) and its [examples](dosh.1.adoc#examples).

Also, here is an extra example that build the documentation

	$ echo FROM ubuntu >Dockerfile
	$ echo RUN apt-get update && apt-get install -y asciidoctor >>Dockerfile

	$ cat Dockerfile
	FROM ubuntu
	RUN apt-get update && apt-get install -y asciidoctor

	$ dosh -c asciidoctor -b manpage -o - dosh.1.adoc | gzip -c - >dosh.1.gz
	sha256:ced062433e33

	$ man ./dosh.1.gz

Enjoy!

## BUGS

Report bugs at *https://github.com/gazoo74/dosh/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@savoirfairelinux.com*

## COPYRIGHT

Copyright (c) 2017 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the MIT License.
