# Docker Shell

[![Packaging status](https://repology.org/badge/vertical-allrepos/dosh.svg)](https://repology.org/project/dosh/versions)

## NAME

[dosh][dosh(1)] - run a user shell in a container with cwd bind mounted

## DESCRIPTION

[dosh(1)] is an _sh-compatible_ frontend for [docker] that runs commands in a
new container; using the current _user_, with _cwd_ bind mounted.

Commands are read either from the standard input or from a file or from command
line using one of the standard shell invocations (i.e. thanks to options `-c`,
`-i`, `-s` or without arguments).

## DOCUMENTATION

Build the documentation using *make(1)*

	$ make doc
	asciidoctor -b manpage -o dosh.1 dosh.1.adoc
	gzip -c dosh.1 >dosh.1.gz
	rm dosh.1

## INSTALL

Run the following command to install *dosh(1)*

To your home directory

	$ make user-install

Or, to your system

	$ sudo make install

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo make install PREFIX=/opt/dosh

Or

	$ make install DESTDIR=$PWD/pkg PREFIX=/usr

## TUNING

### DEFAULT SHELL INTERPRETER

[dosh(1)] uses `/bin/sh` as default interpreter as it is the only reliable Shell
available. The default interpreter can be set by option `--shell SHELL`; but it
needs to be set to every call to *dosh*.

	dosh --shell /bin/bash

Instead, the default interpreter can be set using the `DOSHELL` environment
variable. When this variable is exported, there is no need to override the Shell
interpreter through the command-line.

Adding these two following lines to the Shell `~/.profile` to tell *dosh* to
use `/bin/bash` as Shell interpreter.

	DOSHELL="/bin/bash"
	export DOSHELL

### MANAGE DOSH AS A NON-ROOT USER

[dosh(1)] relies on the setup of Docker. See its documentation to run Docker as
[non-root-user].

It is not recommended to run [dosh(1)] using `sudo` in case the user does not
have permission to send the context to the Docker daemon. Instead, consider
using the option `--sudo` as it will only run the `docker` commands with the
superuser privileges.

On Linux, if you are not a member of the `docker` group, please consider to run
`dosh` as below:

	dosh --sudo

### DOCKER EXTRA OPTIONS

Every [docker(1)][docker] command performed in [dosh(1)] can be customized by
passing extra arguments thanks its corresponding **DOSH_DOCKER_xxx_EXTRA_OPTS**
environment variable. **xxx** represents one of the *docker* commands used in
*dosh* (*build*, *rmi*, *run*, *exec*, *attach*, *kill* and *rm*).

_Note:_ Only `DOSH_DOCKER_RUN_EXTRA_OPTS` is relevant for interactive usage.

As an example, consider mapping extra personal *dot-files* to feel at home in
the container.

Adding these two following lines to the Shell `~/.profile` automatically binds
the `~/.ssh` directory to the container.

	DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $HOME/.ssh:$HOME/.ssh"
	export DOSH_DOCKER_RUN_EXTRA_OPTS

### INITIALIZATION FILES

[dosh(1)] reads and executes commands from initialization files when it is
invoked.

Unlike the standard shells, [dosh(1)] uses files from *personal* and *local*
locations instead of files from *system* and *personal* locations. The *system*
initialization file is replaced by a *local* file; and that *local* file is run
after the *personal* file.

In short, the *personal* file `~/.dosh_profile` is read first, and the *local*
file `./doshrc` is read then. The former file is hidden to avoid polutting the
*personal* directory (as `.profile`, `.bash_profile`, `.bashrc`...) while the
later is not (like `Makefile`, `Dockerfile`...).

The Shell initialization files (`.profile`, `.bash_profile`, `.bashrc`...) are
read by the host shell. The *dosh* specific [environment-variables] are string
variables, and they have to be exported to be part of the environment of the
*dosh(1)* sub-process.

Both *dosh* initialization files aim to override the *dosh* specific variables.
The extra options [environment-variables] are converted to *bash(1)* arrays
before the initialization files are read by *dosh(1)*. They have to remain
*bash(1)* arrays.

### SHELL PROFILE EXAMPLES

Here are some examples of code to copy/paste in the `~/.profile`.

They significantly improve the *dosh* experience.

#### REUSE SAME SHELL INTERPRETER

This asks *dosh* to use the same Shell interpreter as the one which is currently
in use.

	# Not sh?
	if [ "$SHELL" != "/bin/sh" ]
	then
		export DOSHELL="$SHELL"
	fi

_Important:_ Be aware that when the Shell interpreter is not installed in the
container, *dosh* ends with the following error:

	docker: Error response from daemon: oci runtime error: container_linux.go:265: starting container process caused "exec: \"/bin/zsh\": stat /bin/zsh: no such file or directory".

#### EXPORT ENVIRONMENT

These following lines export some useful environment variables to the container.

	# Export some environment variables
	for env in TERM EDITOR
	do
		[ -n "$env" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env $env"
	done

#### MAP DOT-FILES

These following lines map some useful *dot-files* to the container.

	# Map some home dot-files
	for vol in $HOME/.config $HOME/.local $HOME/.profile
	do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

	# Map extra home dot-files
	for vol in $HOME/.inputrc $HOME/.gnupg $HOME/.screenrc
	do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

*bash(1)* invocation files is a *must-have* to feel like home.

	# Map bash dot-files
	for vol in $HOME/.bash{_profile,rc,login,logout}
	do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

*zsh(1)* too.

	# Map zsh dot-files
	zdotdir="${ZDOTDIR:-$HOME}"
	for vol in $zdotdir/.zshenv $zdotdir/.zprofile $zdotdir/.zshrc $HOME/.zlogin $HOME/.zlogout
	do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

#### SSH HANDLING

For a better experience with *SSH*, these following lines should be considered.

	# Map and export ssh things?
	if [ -d "$HOME/.ssh" ]
	then
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $HOME/.ssh:$HOME/.ssh"
	fi
	if [ -n "$SSH_AUTH_SOCK" ]
	then
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env SSH_AUTH_SOCK"
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $SSH_AUTH_SOCK:$SSH_AUTH_SOCK"
	fi

#### X

To enable *X* in docker, these following lines should be considered.

	# Map and export X things?
	if [ -n "$DISPLAY" ]
	then
		for env in DISPLAY XAUTHORITY XSOCK
		do
			[ -n "$env" ] || continue
			DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env $env"
		done
		dotxauthority="${XAUTHORITY:-$HOME/.Xauthority}"
		if [ -e "$dotxauthority" ]
		then
			DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $dotxauthority:$HOME/.Xauthority"
		fi
		unset dotxauthority
		xsock="${XSOCK:-/tmp/.X11-unix}"
		if [ -e "$xsock" ]
		then
			DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $xsock:/tmp/.X11-unix:ro"
		fi
		unset xsock
	fi

_Note_: To enable *X* through *SSH*, please have a look to the excellent post
of Jean-Tiare Le Bigot on its blog [yadutaf].

#### MAKE THE PROMPT SLIGHTLY DIFFERENT

Colorize the prompt from the container in a different way to distinguish *dosh*
sessions.

	# In dosh?
	if [ -z "$DOSHLVL" ]
	then
		return
	fi

	# Colorize prompt color differently
	PS1="${PS1//32/33}"
	PROMPT="${PROMPT//blue/green}"

_Note_: Put these lines to the end of the file.

Lines after the if statement are applied in the container.

## USE PODMAN

[podman] is a daemonless alternative to [docker] providing the same command
line interface, and it can replace [docker] without any troubles.

Adding these two following lines to the Shell `~/.profile` to tell *dosh* to
use `/usr/bin/podman` to run `docker` commands:

	DOSH_DOCKER="/usr/bin/podman"
	export DOSH_DOCKER

Also, disable the context using option `--no-auto-context`.

Additionally, for Rootless containers, consider adding the two following extra
run options to map host UID and GIDs to the container and run it inside a user
namespace.

Add either the following line to the Shell `~/.profile`:

	DOSH_DOCKER_RUN_EXTRA_OPTS="--userns keep-id --group-add keep-groups"

Or the following line to the dosh `~/.dosh_profile`:

	DOSH_DOCKER_RUN_EXTRA_OPTS+=(--userns keep-id --group-add keep-groups`)

Alternatively, use the convenient wrapper script [posh](support/posh) to run
[dosh] using [podman] underneath without touching the Shell and *dosh* files.

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

## PATCHES

Sumbit patches at *https://github.com/gportay/dosh/pulls*

## BUGS

Report bugs at *https://github.com/gportay/dosh/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@gmail.com*

## COPYRIGHT

Copyright 2017-2020,2023-2024 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation, either version 2.1 of the License, or (at your option) any
later version.

[docker]: https://github.com/docker/docker
[non-root-user]: https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
[dosh]: dosh
[dosh(1)]: dosh.1.adoc
[doc]: Makefile#L13-L16
[environment-variables]: https://github.com/gportay/dosh/blob/master/dosh.1.adoc#environment-variables
[examples]: dosh.1.adoc#examples
[yadutaf]: https://blog.yadutaf.fr/2017/09/10/running-a-graphical-app-in-a-docker-container-on-a-remote-server/
[podman]: https://github.com/containers/podman
[posh]: support/posh
