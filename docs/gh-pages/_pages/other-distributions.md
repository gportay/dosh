---
title: "Compile for another distribution"
permalink: /other-distributions/
excerpt: "Compile your application with the toolchain and the libraries of the distribution it targets, without installing that distribution."
---

An application compiled on your machine links against the libraries of your
distribution; it may not run on an older release, or on another distribution.
Compile it in a container of the target distribution instead, and keep working
from your machine.

## Describe the target distribution

Write a `Dockerfile` per target distribution, with its toolchain and the
development packages of your application. For example, to target Ubuntu 22.04:

```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y build-essential
```

Save it as `docker/ubuntu-22.04/Dockerfile`.

## Compile the application

Run the build in the target distribution, from your source tree:

```console
$ dosh --dockerfile docker/ubuntu-22.04/Dockerfile -c "make"
```

The build runs as you, so the binaries land in your working directory, owned
by you, ready to ship. Add a `Dockerfile` per release or distribution to
target, and compile for each of them the same way.

## Ready-to-use Dockerfiles

dosh comes with Dockerfiles installed under `/usr/share/dosh/docker/`, such as
`ubuntu/Dockerfile` for Ubuntu 24.04, and `raspberrypios/Dockerfile` for
Raspberry Pi OS. Use them as a starting point:

```console
$ dosh --dockerfile /usr/share/dosh/docker/ubuntu/Dockerfile
```

Combine the target distribution with the option `--platform` to target another
architecture too. See [Package for multiple architectures].

[Package for multiple architectures]: {{ "/multi-architecture/" | relative_url }}
