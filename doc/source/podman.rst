.. SPDX-License-Identifier: LGPL-2.1-or-later

Use Podman
==========

`podman`_ is a daemonless alternative to `docker`_ providing the same command
line interface, and it can replace `docker`_ without any trouble.

Add the following two lines to the shell ``~/.profile`` to tell *dosh* to use
``/usr/bin/podman`` to run ``docker`` commands:

::

	DOSH_DOCKER="/usr/bin/podman"
	export DOSH_DOCKER

Also, disable the context using the option ``--no-auto-context``.

Additionally, for rootless containers, consider adding the following two extra
run options to map the host UID and GIDs to the container and run it inside a
user namespace.

Add either the following line to the shell ``~/.profile``:

::

	DOSH_DOCKER_RUN_EXTRA_OPTS="--userns keep-id --group-add keep-groups"

Or the following line to the dosh ``~/.dosh_profile``:

::

	DOSH_DOCKER_RUN_EXTRA_OPTS+=(--userns keep-id --group-add keep-groups)

Alternatively, use the convenient wrapper script `posh`_ to run `dosh`_ using
`podman`_ underneath without touching the shell and *dosh* files.
