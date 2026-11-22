---
title: "News"
permalink: /news/
excerpt: "dosh releases and announcements."
---

### dosh documentation on <mark>Read the Docs</mark>

18 November 2026

The dosh documentation is now on [Read the Docs]! It covers the installation,
the requirements, the cross-platform builds, Podman, and more.

### <mark>dosh 9</mark> released

12 January 2026

dosh 9 is out! It adds the `--cache-directory` and `--rc` options, prints the
commands and the raw build process when `--verbose`, and adds the `Running`
image status. Images are now built from the `Dockerfile`'s parent directory,
cached by backend, and never garbage collected while a container is running.
See the [CHANGELOG][changelog-9] for details.

Grab the [dosh 9 release][release-9].

### <mark>dosh 8</mark> released

1 August 2025

dosh 8 is out! It adds the `--platform` option and the `DOSH_PLATFORM`
environment variable to support [multi-platform] images, and the `--parent`
option to bind mount the parent directory. The `--ls` output gets a `PLATFORM`
column. It also fixes relative paths with `--working-directory` and the
collection of unused images. See the [CHANGELOG][changelog-8] for details.

Grab the [dosh 8 release][release-8].

[Read the Docs]: https://dosh.readthedocs.io/
[multi-platform]: https://docs.docker.com/build/building/multi-platform/
[changelog-9]: https://github.com/gportay/dosh/blob/9/CHANGELOG.md
[changelog-8]: https://github.com/gportay/dosh/blob/8/CHANGELOG.md
[release-9]: https://github.com/gportay/dosh/releases/tag/9
[release-8]: https://github.com/gportay/dosh/releases/tag/8
