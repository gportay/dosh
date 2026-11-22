---
title: "Run it with any Docker Engine"
permalink: /compatibility/
excerpt: "dosh works with any Docker Engine, including Podman. It runs on Linux and on Windows with WSL."
---

dosh is a bash script running the `docker` command line. It works with any
engine providing that command line, including Docker Engine, Docker Desktop
and Podman.

## Use Podman

[Podman] is a daemonless alternative to Docker providing the same command line
interface, and it can replace Docker without any trouble.

Add the following two lines to the shell `~/.profile` to tell dosh to use
`/usr/bin/podman` to run `docker` commands:

```sh
DOSH_DOCKER="/usr/bin/podman"
export DOSH_DOCKER
```

Also, disable the context using the option `--no-auto-context`.

For rootless containers, map the host UID and GIDs to the container and run it
inside a user namespace:

```sh
DOSH_DOCKER_RUN_EXTRA_OPTS="--userns keep-id --group-add keep-groups"
```

Alternatively, use the convenient wrapper script `posh` to run dosh using
Podman underneath without touching the shell and dosh files.

## Use WSL

On Windows, install dosh in a Linux distribution running in [WSL]. Use it with
a Docker Engine or Podman installed in that distribution, or with Docker
Desktop and its WSL integration enabled.

## Run without root

dosh relies on the setup of Docker. If you are not a member of the `docker`
group, use the option `--sudo`: it only runs the `docker` commands with
superuser privileges.

```console
$ dosh --sudo
```

[Podman]: https://github.com/containers/podman
[WSL]: https://learn.microsoft.com/windows/wsl/

<a class="btn btn--primary" href="https://dosh.readthedocs.io/en/latest/podman.html">Read the documentation</a>
