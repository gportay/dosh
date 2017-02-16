# docker-scripts

## NAME

[dsh](dsh.1.adoc) - run a user shell in a container with pwd bind mounted

[dmake](dmake.1.adoc) - maintain program dependencies running commands in
container

[docker-clean](docker-clean.1.adoc) - remove unused containers and images

## DESCRIPTION

[dsh](dsh) runs the _command_ process in a container; using the current _user_,
with _pwd_ bind mounted.

[dmake](dmake) runs on top of *make(1)* using [dsh(1)](dsh.1.adoc) as default
_shell_.

[docker-clean](docker-clean) removes exited containers and dangling images that
take place for nothing.

## DOCUMENTATION

Build documentation using _build-doc.dsh_ *dsh(1)* script

	$ ./build-doc.dsh
	sha256:ced062433e33

Or using *dmake(1)* and _Makefile_

	$ dmake
	sha256:ced062433e33
	asciidoctor -b manpage -o dsh.1 dsh.1.adoc
	gzip -c dsh.1 >dsh.1.gz
	asciidoctor -b manpage -o dmake.1 dmake.1.adoc
	gzip -c dmake.1 >dmake.1.gz
	rm dsh.1 dmake.1
	83727c98a60a9648b20d127c53526e785a051cef2235702071b8504bb1bdca59

## INSTALL

Run the following command to install *dsh(1)*

	$ sudo ./install.sh

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo PREFIX=/opt/dsh ./install.sh

or

	$ DESTDIR=$PWD/pkg PREFIX=/usr ./install.sh

## LINKS

Check for man-pages ([dsh(1)](dsh.1.adoc), [dmake(1)](dmake.1.adoc) and
[docker-clean(1)](docker-clean.1.adoc)) and theirs examples
([dsh](dsh.1.adoc#examples), [dmake](dmake.1.adoc#examples) and
[docker-clean](docker-clean.1.adoc#examples)).

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
