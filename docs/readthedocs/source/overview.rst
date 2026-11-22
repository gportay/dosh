.. SPDX-License-Identifier: LGPL-2.1-or-later

Overview
========

TL;DR;
------

`dosh <dosh(1)_>`_ is a bash script providing a shell CLI to *docker-run(1)*.

It runs a user shell in a container built from a Dockerfile, with the working
directory bind mounted.

In short, ``dosh`` does...

::

	docker run --rm [--tty] [--interactive] "--volume=$PWD:$PWD:rw" "--user=$USER" "--entrypoint=$SHELL" IMAGE [SHELL_ARGS]

... with a little more magic!

**Important**: `dosh <dosh(1)_>`_ reads the Dockerfile from the subdirectory
``docker/``, and it falls back to the current working directory for historical
reason. docker-build sends a lot of data to the Docker daemon depending on the
contents of the Dockerfile's parent directory. dosh does its best to limit the
context sent to the docker daemon by doing a very limited magic if the
Dockerfile contains ADD or COPY instructions to send local files. Consider
using subdirectory ``docker/`` to disable this very limited feature as dosh does
not fully implement a Dockerfile parser as defined in the `Dockerfile`_
reference.

Name
----

`dosh <dosh(1)_>`_ - run a user shell in a container with working directory
bind mounted

Description
-----------

`dosh(1)`_ is an *sh-compatible* front-end for `docker`_ that runs commands in
a new container, using the current *user*, with the *working directory* bind
mounted.

Commands are read either from the standard input, from a file, or from the
command line, using one of the standard shell invocations (i.e. options ``-c``,
``-i``, ``-s``, or no arguments).
