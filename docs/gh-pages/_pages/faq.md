---
title: "Frequently Asked Questions"
permalink: /faq/
excerpt: "Answers to the common questions about dosh."
---

## What does dosh <mark>do exactly</mark>?

In short, dosh does:

```console
$ docker run --rm [--tty] [--interactive] "--volume=$PWD:$PWD:rw" "--user=$USER" "--entrypoint=$SHELL" IMAGE [SHELL_ARGS]
```

... with a little more magic! It builds `IMAGE` from your `Dockerfile` when
needed, and maps your user and groups into the container. See the
[getting started] page.

## Which <mark>container engines</mark> does dosh support?

dosh works with any Docker Engine, and with [Podman]. Tell dosh to run Podman
in your `~/.profile`:

```bash
DOSH_DOCKER="/usr/bin/podman"
export DOSH_DOCKER
```

Or, use the wrapper `posh` shipped with dosh. See the [compatibility] page.

## Which <mark>operating systems</mark> does dosh run on?

dosh runs on Linux and on Windows with WSL. dosh is a bash script;
it requires bash 4.2 or later on the host. The shell run in the container
does not need to be bash. See the [download page].

## Where does dosh look for the <mark>Dockerfile</mark>?

dosh reads the `Dockerfile` from the subdirectory `docker/`, and it falls back
to the current working directory for historical reason. Select another
`Dockerfile` with the option `--dockerfile`, or with the variable
`DOSH_DOCKERFILE`.

Prefer the subdirectory `docker/`: docker sends the content of the
`Dockerfile`'s parent directory to the Docker daemon at build.

## Who <mark>owns the files</mark> created in the container?

You do. dosh runs the container as your user, with your user ID and group, so
the files created in your working directory belong to you, as if you had
created them on the host.

## Can I access my <mark>home</mark> or the <mark>parent directory</mark>?

By default, dosh only mounts the working directory. Use the option `--home` to
mount your home directory, or the option `--parent` to mount the parent
directory.

## Does dosh <mark>rebuild</mark> the image every time?

No. dosh tags the image with the checksum of the `Dockerfile`, and it builds
the image only if it does not exist yet, or if the `Dockerfile` changes. Use the
option `--build` to build the image anyway, or `--rebuild` to build it again
verbosely.

## How do I <mark>clean up</mark> the dosh images?

List the images with the option `--ls`, remove the image of the current
`Dockerfile` with the option `--rmi`, and remove the unused images with the
option `--gc`.

## Why does dosh fail with <mark>"no such file or directory"</mark>?

The shell to run is not installed in the image. dosh runs `/bin/sh` by default;
if you set `DOSHELL` or the option `--shell` to another shell, such as
`/bin/zsh`, install it in your `Dockerfile`, or choose a shell available in the
image.

## Do I need to be <mark>root</mark> to run dosh?

No. dosh relies on the setup of Docker; see how to run Docker as a
[non-root user]. If you are not a member of the `docker` group, do not run dosh
with `sudo`; use the option `--sudo` instead, it only runs the `docker`
commands with superuser privileges.

## Can dosh build for <mark>another architecture</mark>?

Yes. Use the option `--platform`, for example `--platform linux/arm64`, to
build and run [multi-platform] images. See the [multi-architecture] page.

## How do I see <mark>what dosh runs</mark>?

Use the option `--verbose` to print the `docker` commands, or the option
`--dry-run` to print them without running them.

## Where can I get <mark>help</mark>?

Visit the [support page].

[getting started]: {{ "/getting-started/" | relative_url }}
[compatibility]: {{ "/compatibility/" | relative_url }}
[download page]: {{ "/download/" | relative_url }}
[multi-architecture]: {{ "/multi-architecture/" | relative_url }}
[support page]: {{ "/support/" | relative_url }}
[Podman]: https://podman.io/
[non-root user]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
[multi-platform]: https://docs.docker.com/build/building/multi-platform/
