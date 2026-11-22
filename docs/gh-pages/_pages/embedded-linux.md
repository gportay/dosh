---
title: "Build embedded Linux systems"
permalink: /embedded-linux/
excerpt: "Build Yocto, OpenEmbedded and Buildroot projects directly inside containers, without the overhead of a virtual machine or changes to your existing build workflow."
---

Embedded Linux build systems require a long list of host packages, often in
specific versions. dosh provides them in a container, while the build runs in
your working directory, as your user, exactly as on the host.

Running as your user matters: *bitbake* refuses to run as root, and the build
artifacts belong to you once the build is over.

## Ready-to-use Dockerfiles

dosh comes with Dockerfiles for the common embedded Linux build systems. The
distribution packages install them under `/usr/share/dosh/docker/`:

| Dockerfile                 | Environment                    |
| -------------------------- | ------------------------------ |
| `yocto/Dockerfile`         | Yocto Project and OpenEmbedded |
| `kas/Dockerfile`           | Yocto Project with kas         |
| `raspberrypios/Dockerfile` | Raspberry Pi OS                |

## Build with Yocto

Source the build environment and run *bitbake* from the Poky directory:

```console
$ dosh --dockerfile /usr/share/dosh/docker/yocto/Dockerfile --shell /bin/bash
$ source oe-init-build-env
$ bitbake core-image-minimal
```

## Build with Buildroot

Buildroot ships its own Dockerfile. Run the build from the Buildroot directory
using it:

```console
$ dosh --dockerfile support/docker/Dockerfile -c "make qemu_x86_64_defconfig all"
```

<a class="btn btn--primary" href="https://github.com/gportay/dosh/tree/master/docker">Browse the Dockerfiles</a>
