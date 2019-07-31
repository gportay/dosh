# Docker Shell

## NAME

[dosh][dosh(1)] - run a user shell in a container with pwd bind mounted

## DESCRIPTION

[dosh(1)] is an _sh-compatible_ frontend that runs commands in a [docker]
container; using the current _user_, with _pwd_ bind mounted.

Commands are read either from the standard input or from a file or from command
line using one of the standard shell invocations (i.e. thanks to options `-c`,
`-i`, `-s` or without arguments).

Think [dosh(1)] as a _shell_ frontend wrapper on top of _docker-run(1)_ written
in _bash_.

## DOWNLOAD

Give it a try right now by fetching your own copy!

*Version* | *Checksum* (\*)                  |
--------- | -------------------------------- |
[1.5]     | 12008869c3e0b096ca4704a7378334a0 |
[1.4]     | dc84c3c938dca91a81d471efdc681081 |
[1.3.1]   | b0ddb7932dd692cf154efbdf29e8df6a |
[1.2.1]   | 4bcf4e3ff14bc13e0b6b2e0333ffcce1 |
[1.1.1]   | dc957c4d062779065b060beaeee612ff |
[1.0.2]   | beebf0e007750891d784745ced2b51eb |

\*: Note that hashes are subject to change as GitHub might update tarball
generation.

## DOCUMENTATION

Build documentation using _examples/build-doc.dosh_ *dosh(1)* script

	$ examples/build-doc.dosh
	sha256:ced062433e33

Or using *make(1)* and _Makefile_

	$ make
	asciidoctor -b manpage -o dosh.1 dosh.1.adoc
	gzip -c dosh.1 >dosh.1.gz
	rm dosh.1

If neither _asciidoctor(1)_ nor _dosh(1)_ are installed on the system, the
documentation can be build using in-tree _dosh_ script

	./dosh -c "bash examples/build-doc.dosh"

## INSTALL

Run the following command to install *dosh(1)*

	$ sudo make install

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo make install PREFIX=/opt/dosh

or

	$ make install DESTDIR=$PWD/pkg PREFIX=/usr

## TUNING

### Default Shell Interpreter

[dosh(1)] uses `/bin/sh` as default interpreter as it is the only reliable Shell
available. The default interpreter can be set by option `--shell SHELL`; but it
needs to be set to every call to *dosh*.

	dosh --shell /bin/bash

Instead, the default interpreter can be set using the `DOSHELL` environment
variable. When this variable is exported, there is no need to override the Shell
interpreter through the command-line.

Adding these two following lines to the Shell `~/.profile` tells *dosh* to uses
`/bin/bash` as Shell interpreter.

	DOSHELL="/bin/bash"
	export DOSHELL

### Docker extra options

Every single [docker(1)][docker] command performed in [dosh(1)] can be customized by
passing extra arguments thanks its corresponding **DOSH_DOCKER_xxx_EXTRA_OPTS**
environment variable. **xxx** represents one of the *docker* commands used in
*dosh* (*build*, *rmi*, *run* and *exec*).

_Note:_ Only `DOSH_DOCKER_RUN_EXTRA_OPTS` is relevant for interactive usage.

As an example, consider mapping extra personal *dot-files* to feel at home in
the container.

Adding these two following lines to the Shell `~/.profile` automatically binds
the `~/.ssh` directory to the container.

	DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $HOME/.ssh:$HOME/.ssh"
	export DOSH_DOCKER_RUN_EXTRA_OPTS

### SHELL PROFILE EXAMPLES

Here are some examples of code to copy/paste in the `.profile`.

They significantly improve the *dosh* experience.

#### REUSE SAME SHELL INTERPRETER

This asks *dosh* to use the same Shell interpreter as the one which is currently
in use.

	# Not sh?
	if [ "$SHELL" != "/bin/sh" ]; then
		export DOSHELL="$SHELL"
	fi

_Important:_ Be aware that when the Shell interpreter is not installed in the
container, *dosh* ends with the following error:

	docker: Error response from daemon: oci runtime error: container_linux.go:265: starting container process caused "exec: \"/bin/zsh\": stat /bin/zsh: no such file or directory".

#### EXPORT ENVIRONMENT

These following lines export some useful environment variables to the container.

	# Export some environment variables
	for env in TERM EDITOR; do
		[ -n "$env" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env $env"
	done

#### MAP DOT-FILES

These following lines map some useful *dot-files* to the container.

	# Map some home dot-files
	for vol in $HOME/.config $HOME/.local $HOME/.profile; do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

	# Map extra home dot-files
	for vol in $HOME/.inputrc $HOME/.gnupg $HOME/.screenrc; do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

*bash(1)* invocation files is a *must-have* to feel like home.

	# Map bash dot-files
	for vol in $HOME/.bash{_profile,rc,login,logout}; do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

*zsh(1)* too.

	# Map zsh dot-files
	zdotdir="${ZDOTDIR:-$HOME}"
	for vol in $zdotdir/.zshenv $zdotdir/.zprofile $zdotdir/.zshrc $HOME/.zlogin $HOME/.zlogout; do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

#### SSH HANDLING

For a better experience with *SSH*, these following lines should be considered.

	# Map and export ssh things?
	if [ -d "$HOME/.ssh" ]; then
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $HOME/.ssh:$HOME/.ssh"
	fi
	if [ -n "$SSH_AUTH_SOCK" ]; then
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env SSH_AUTH_SOCK"
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $SSH_AUTH_SOCK:$SSH_AUTH_SOCK"
	fi

#### X

To enable *X* in docker, these following lines should be considered.

	# Map and export X things?
	if [ -n "$DISPLAY" ]; then
		for env in DISPLAY XAUTHORITY XSOCK; do
			[ -n "$env" ] || continue
			DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env $env"
		done
		dotxauthority="${XAUTHORITY:-$HOME/.Xauthority}"
		if [ -e "$dotxauthority" ]; then
			DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $dotxauthority:$HOME/.Xauthority"
		fi
		unset dotxauthority
		xsock="${XSOCK:-/tmp/.X11-unix}"
		if [ -e "$xsock" ]; then
			DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $xsock:/tmp/.X11-unix:ro"
		fi
		unset xsock
	fi

_Note_: To enable *X* through *SSH*, please have a look to the excelent post of
Jean-Tiare Le Bigot on its blog [yadutaf].

#### MAKE THE PROMPT SLIGHTLY DIFFERENT

Colorize the prompt from the container in a different way to distinguish *dosh*
sessions.

	# In docker?
	[ -z "$DOSHLVL" ] || return

	# Colorize prompt color differently
	PS1="${PS1//32/33}"
	PROMPT="${PROMPT//blue/green}"

_Note_: Put these lines to the end of the file.

Lines beside `[ -z "$DOSHLVL" ] || return` are applied in the container.

## LINKS

Check for [man-pages][dosh(1)] and its [examples].

Also, here is an extra example that builds the documentation

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

Report bugs at *https://github.com/gportay/dosh/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@gmail.com*

## COPYRIGHT

Copyright (c) 2017-2019 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the MIT License.

[docker]: https://github.com/docker/docker
[dosh]: dosh
[dosh(1)]: dosh.1.adoc
[examples]: dosh.1.adoc#examples
[yadutaf]: https://blog.yadutaf.fr/2017/09/10/running-a-graphical-app-in-a-docker-container-on-a-remote-server/
[1.5]: https://github.com/gportay/dosh/archive/1.5.tar.gz
[1.4]: https://github.com/gportay/dosh/archive/1.4.tar.gz
[1.3.1]: https://github.com/gportay/dosh/archive/1.3.1.tar.gz
[1.2.1]: https://github.com/gportay/dosh/archive/1.2.1.tar.gz
[1.1.1]: https://github.com/gportay/dosh/archive/1.1.1.tar.gz
[1.0.2]: https://github.com/gportay/dosh/archive/1.0.2.tar.gz
