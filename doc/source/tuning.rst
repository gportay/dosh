.. SPDX-License-Identifier: LGPL-2.1-or-later

Tuning
======

.. _default-shell-interpreter:

Default shell interpreter
-------------------------

`dosh(1)`_ uses ``/bin/sh`` as the default interpreter, as it is the only shell
reliably available. The interpreter can be set with the option
``--shell SHELL``, but it then needs to be set on every call to *dosh*.

::

	dosh --shell /bin/bash

Instead, the default interpreter can be set using the ``DOSHELL`` environment
variable. When this variable is exported, there is no need to override the shell
interpreter on the command line.

Add the following two lines to the shell ``~/.profile`` to tell *dosh* to use
``/bin/bash`` as the shell interpreter.

::

	DOSHELL="/bin/bash"
	export DOSHELL

Manage dosh as a non-root user
------------------------------

`dosh(1)`_ relies on the setup of Docker. See its documentation to run Docker
as `non-root-user`_.

If the user does not have permission to send the context to the Docker daemon,
running `dosh(1)`_ with ``sudo`` is not recommended. Instead, consider using the
option ``--sudo``, as it only runs the ``docker`` commands with superuser
privileges.

On Linux, if you are not a member of the ``docker`` group, consider running
``dosh`` as below:

::

	dosh --sudo

Docker extra options
--------------------

Every `docker(1) <docker_>`_ command performed in `dosh(1)`_ can be customized
by passing extra arguments through its corresponding
**DOSH_DOCKER_xxx_EXTRA_OPTS** environment variable. **xxx** represents one of
the *docker* commands used in *dosh* (*build*, *rmi*, *run*, *exec*, *attach*,
*kill* and *rm*).

*Note:* Only ``DOSH_DOCKER_RUN_EXTRA_OPTS`` is relevant for interactive usage.

As an example, consider mapping extra personal *dot-files* to feel at home in
the container.

Adding the following two lines to the shell ``~/.profile`` automatically binds
the ``~/.ssh`` directory to the container.

::

	DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $HOME/.ssh:$HOME/.ssh"
	export DOSH_DOCKER_RUN_EXTRA_OPTS

Initialization files
--------------------

`dosh(1)`_ reads and executes commands from initialization files when it is
invoked.

Unlike the standard shells, `dosh(1)`_ uses files from *personal* and *local*
locations instead of files from *system* and *personal* locations. The *system*
initialization file is replaced by a *local* file, and that *local* file is run
after the *personal* file.

In short, the *personal* file ``~/.dosh_profile`` is read first, and the
*local* file ``./doshrc`` is read next. The former is hidden to avoid polluting
the *personal* directory (like ``.profile``, ``.bash_profile``, ``.bashrc``...)
while the latter is not (like ``Makefile``, ``Dockerfile``...).

The shell initialization files (``.profile``, ``.bash_profile``, ``.bashrc``...)
are read by the host shell. The *dosh*-specific `environment-variables`_ are
string variables, and they have to be exported to be part of the environment of
the *dosh(1)* sub-process.

Both *dosh* initialization files aim to override the *dosh*-specific variables.
The extra options `environment-variables`_ are converted to *bash(1)* arrays
before the initialization files are read by *dosh(1)*. They have to remain
*bash(1)* arrays.

Shell profile examples
----------------------

Here are some examples of code to copy/paste in the ``~/.profile``.

They significantly improve the *dosh* experience.

Reuse same shell interpreter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This tells *dosh* to use the same shell interpreter as the one currently in use.

::

	# Not sh?
	if [ "$SHELL" != "/bin/sh" ]
	then
		export DOSHELL="$SHELL"
	fi

*Important:* Be aware that when the shell interpreter is not installed in the
container, *dosh* ends with the following error:

::

	docker: Error response from daemon: oci runtime error: container_linux.go:265: starting container process caused "exec: \"/bin/zsh\": stat /bin/zsh: no such file or directory".

Export environment
~~~~~~~~~~~~~~~~~~

The following lines export some useful environment variables to the container.

::

	# Export some environment variables
	for env in TERM EDITOR
	do
		printenv "$env" >/dev/null || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --env $env"
	done

Map dot-files
~~~~~~~~~~~~~

The following lines map some useful *dot-files* to the container.

::

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

*bash(1)* invocation files are a *must-have* to feel at home.

::

	# Map bash dot-files
	for vol in $HOME/.bash{_profile,rc,login,logout}
	do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

*zsh(1)* too.

::

	# Map zsh dot-files
	zdotdir="${ZDOTDIR:-$HOME}"
	for vol in $zdotdir/.zshenv $zdotdir/.zprofile $zdotdir/.zshrc $HOME/.zlogin $HOME/.zlogout
	do
		[ -e "$vol" ] || continue
		DOSH_DOCKER_RUN_EXTRA_OPTS+=" --volume $vol:$vol"
	done

SSH handling
~~~~~~~~~~~~

For a better experience with *SSH*, consider the following lines.

::

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

X
~

To enable *X* in docker, consider the following lines.

::

	# Map and export X things?
	if [ -n "$DISPLAY" ]
	then
		for env in DISPLAY XAUTHORITY XSOCK
		do
			printenv "$env" >/dev/null || continue
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

*Note*: To enable *X* through *SSH*, have a look at the excellent post by
Jean-Tiare Le Bigot on his blog `yadutaf`_.

Make the prompt slightly different
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Colorize the prompt in the container differently to distinguish *dosh*
sessions.

::

	# In dosh?
	if [ -z "$DOSHLVL" ]
	then
		return
	fi

	# Colorize prompt color differently
	PS1="${PS1//32/33}"
	PROMPT="${PROMPT//blue/green}"

*Note*: Put these lines at the end of the file.

Lines after the if statement only apply in the container.
