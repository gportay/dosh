---
title: "Package for multiple architectures"
permalink: /multi-architecture/
excerpt: "Build Debian and RPM packages for different target architectures using multi-platform container images."
---

dosh builds and runs images for another platform if the option `--platform` is
set to a target different from the host platform (`linux/amd64`,
`linux/arm64`...).

```console
$ dosh -c "uname -m"
x86_64

$ dosh --platform linux/arm64 -c "uname -m"
aarch64
```

Running images for a foreign platform requires emulation on the host, as
described in the Docker [multi-platform] documentation.

## Platform helper scripts

Alternatively, use the specific platform helper scripts to run dosh using the
platform prefixed in the executable filename: `linux-amd64-dosh`,
`linux-arm64-dosh`, `linux-arm-dosh`, `linux-arm-v6-dosh`, `linux-arm-v7-dosh`,
`linux-ppc64le-dosh`, `linux-riscv64-dosh` and `linux-s390x-dosh`.

```console
$ linux-arm64-dosh -c "uname -m"
aarch64
```

## Build Debian and RPM packages

dosh comes with Dockerfiles to build packages, installed under
`/usr/share/dosh/docker/`: `deb/Dockerfile` for Debian packages, and
`rpm/Dockerfile` for RPM packages. dosh builds its own packages this way:

```console
$ linux-arm64-dosh --dockerfile /usr/share/dosh/docker/deb/Dockerfile -c "dpkg-buildpackage -us -uc"
```

[multi-platform]: https://docs.docker.com/build/building/multi-platform/

<a class="btn btn--primary" href="https://dosh.readthedocs.io/en/latest/cross-platform.html">Read the documentation</a>
