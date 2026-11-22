---
title: "Getting Started"
permalink: /getting-started/
excerpt: "Run your first command with dosh, the way dosh builds itself."
---

dosh is its own first user: the project uses dosh to build its man page, its
documentation, and its packages. This page walks you through these examples.

## <mark>Install</mark> dosh

Follow the [download page] to install dosh and [Docker].

```console
$ dosh --version
```

## Write a <mark>Dockerfile</mark>

dosh reads the `Dockerfile` from the subdirectory `docker/` of your working
directory. Describe the tools your project needs, as you would set up a
development machine. For example, to build the dosh man page:

```console
$ mkdir docker
$ echo "FROM ubuntu" >docker/Dockerfile
$ echo "RUN apt-get update && apt-get install -y asciidoctor" >>docker/Dockerfile
```

## Run a <mark>command</mark>

Run your command with `dosh -c`, as you would with `sh -c`:

```console
$ dosh -c "asciidoctor -b manpage -o - dosh.1.adoc | gzip -c - >dosh.1.gz"
#0 building with "default" instance using docker driver
...
$ man ./dosh.1.gz
```

dosh builds the image the first time, and reuses it until the `Dockerfile`
changes. The command runs as you, in a throwaway container, and the file
`dosh.1.gz` lands in your working directory.

Or, run `dosh` alone to open an interactive shell in the container:

```console
$ dosh
```

## Use one <mark>Dockerfile</mark> per task

A project often needs several environments. Select one with the option
`--dockerfile`, or with the environment variable `DOSH_DOCKERFILE`. The dosh
sources keep one `Dockerfile` per task:

| Dockerfile                  | Builds                          |
| --------------------------- | ------------------------------- |
| `docker/asciidoctor/`       | the man page                    |
| `docker/sphinx/`            | the documentation               |
| `docker/jekyll/`            | this website                    |
| `docker/deb/`               | the Debian package              |
| `docker/rpm/`               | the RPM package                 |
| `docker/pkg/`               | the Arch Linux package          |

For example, to build the documentation:

```console
$ dosh --dockerfile docker/sphinx/Dockerfile -c "make -C docs/readthedocs html"
```

## Configure dosh with <mark>startup files</mark>

When dosh starts, it reads the personal file `~/.dosh_profile` first, and the
local file `./doshrc` of your working directory next, if they exist. These
startup files are bash scripts run by dosh on the host, not in the container.
They set the dosh variables, such as the shell to run, or extra options for
`docker run`.

dosh runs `/bin/sh` by default, as it is the only shell reliably available. Set
your preferred shell with the variable `DOSHELL` in your `~/.dosh_profile`:

```bash
DOSHELL=/bin/bash
```

Or, reuse the shell you are running on the host, if it is installed in your
containers:

```bash
DOSHELL="$SHELL"
```

The dosh sources ship a `doshrc` that tunes each environment. For example, it
publishes the ports of this website, when the Jekyll `Dockerfile` is used:

```bash
case "$DOSH_DOCKERFILE" in
docker/jekyll/Dockerfile)
	DOSH_DOCKER_RUN_EXTRA_OPTS+=(--publish 4000:4000)
	DOSH_DOCKER_RUN_EXTRA_OPTS+=(--publish 35729:35729)
	;;
esac
```

Use the options `--no-doshprofile` and `--no-doshrc` to skip these files.

## Use dosh from a <mark>Makefile</mark>

Set dosh as the `SHELL` of a target, and its recipe runs in the container. The
dosh `Makefile` builds its documentation this way:

```make
.PHONY: doc
doc: SHELL = dosh
doc: .SHELLFLAGS = --dockerfile docker/sphinx/Dockerfile -c
doc:
	$(MAKE) -C docs/readthedocs html
```

And its Debian package:

```make
.PHONY: deb
deb: SHELL = dosh
deb: export DOSH_DOCKERFILE = docker/deb/Dockerfile
deb:
	dpkg-buildpackage -us -uc
	lintian ../dosh*.dsc ../dosh*.deb
```

Then, `make doc` and `make deb` need nothing else than dosh and Docker on your
machine.

## Use dosh as a <mark>shebang</mark>

dosh is also an interpreter for shell scripts: start a script with
`#!/usr/bin/env dosh`, and it runs in the container. Pass dosh options with the
split option `-S` of `env`. The dosh sources build the man page with
`examples/build-man.dosh`:

```bash
#!/usr/bin/env -S dosh --shell /bin/bash
set -e
set -o pipefail

asciidoctor -b manpage -o - dosh.1.adoc | gzip -c - >dosh.1.gz
```

And the Arch Linux package with `make-pkg.sh`:

```bash
#!/usr/bin/env -S DOSH_DOCKERFILE=docker/pkg/Dockerfile dosh --no-doshrc
set -e
makepkg --force --skipchecksums "$@"
```

Make the script executable, and run it as any other script:

```console
$ chmod +x make-pkg.sh
$ ./make-pkg.sh
```

## Share your host settings with <mark>rc files</mark>

dosh ships ready-to-use rc files that bring your host settings into the
container. Load them with the option `--rc`, or with the variable `DOSHRC` in
your `~/.dosh_profile`:

```console
$ dosh --rc git.rc,ssh-agent.rc
```

| rc file         | Shares                                          |
| --------------- | ----------------------------------------------- |
| `git.rc`        | your `~/.gitconfig`                             |
| `ssh.rc`        | your `~/.ssh` directory                         |
| `ssh-agent.rc`  | your SSH agent                                  |
| `shell.rc`      | your shell startup files, such as `~/.bashrc`   |
| `history.rc`    | a shell history per working directory           |
| `x11.rc`        | your X11 display                                |

dosh looks for the rc files in the working directory, then in
`~/.local/share/dosh/rc.d`, `/usr/local/share/dosh/rc.d` and
`/usr/share/dosh/rc.d`. Write your own in `~/.local/share/dosh/rc.d`.

## Go <mark>further</mark>

Read the [documentation] to learn about the options, the multi-platform builds,
and Podman. Have a question? Visit the [support page].

[download page]: {{ "/download/" | relative_url }}
[support page]: {{ "/support/" | relative_url }}
[Docker]: https://docs.docker.com/engine/install/
[documentation]: https://dosh.readthedocs.io/
