# dsh(1)

## NAME

[dsh](dsh.1.adoc) - run a user shell in a container with pwd bind mounted

## DESCRIPTION

[dsh](dsh) runs the _command_ process in a container; using the current _user_,
with _pwd_ bind mounted.

## DOCUMENTATION

Build documentation using _build-doc.dsh_ *dsh(1)* script

	$ ./build-doc.dsh
	sha256:ced062433e33

## INSTALL

Run the following command to install *dsh(1)*

	$ sudo ./install.sh

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo PREFIX=/opt/dsh ./install.sh

or

	$ DESTDIR=$PWD/pkg PREFIX=/usr ./install.sh

## LINKS

Check for the [man-page](dsh.1.adoc) and its [examples](dsh.1.adoc#examples)
section.

Also, here is an extra example that build the documentation

	$ echo FROM ubuntu >Dockerfile
	$ echo RUN apt-get update && apt-get install -y asciidoctor >>Dockerfile

	$ cat Dockerfile
	FROM ubuntu
	RUN apt-get update && apt-get install -y asciidoctor

	$ dsh -c asciidoctor -b manpage -o - dsh.1.adoc | gzip -c - >dsh.1.gz
	sha256:ced062433e33

	$ man ./dsh.1.gz

Enjoy!

## BUGS

Report bugs at *https://github.com/gazoo74/docker-scripts/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@savoirfairelinux.com*

## COPYRIGHT

Copyright (c) 2017 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the MIT License.
