.. SPDX-License-Identifier: LGPL-2.1-or-later

Use cross platform
==================

`dosh(1)`_ builds and runs images for another
`platform <multi-platform_>`_ if the option ``--platform`` is set to a target
different from the host platform (``linux/amd64``, ``linux/arm64``...).

::

	$ dosh -c "uname -m"
	x86_64

	$ dosh --platform linux/arm64 -c "uname -m"
	WARNING: The requested image's platform (linux/arm64) does not match the detected host platform (linux/amd64/v3) and no specific platform was requested
	aarch64

Alternatively, use the specific platform helper scripts (``linux-amd64-dosh``,
``linux-arm64-dosh``) to run `dosh`_ using the platform prefixed in the
executable filename.

::

	$ linux-arm64-dosh -c "uname -m"
	WARNING: The requested image's platform (linux/arm64) does not match the detected host platform (linux/amd64/v3) and no specific platform was requested
	aarch64
