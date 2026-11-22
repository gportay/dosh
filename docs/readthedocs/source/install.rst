.. SPDX-License-Identifier: LGPL-2.1-or-later

Install
=======

From packages
-------------

Arch Linux derivatives
~~~~~~~~~~~~~~~~~~~~~~

First, download the package:

::

	$ curl -LO https://github.com/gportay/dosh/releases/download/9/dosh-9-1-any.pkg.tar.zst

Then, install it using the package manager:

::

	$ sudo pacman -U ./dosh-9-1-any.pkg.tar.zst

*Note*: Uninstall it using the package manager:

::

	$ sudo pacman -R dosh

Debian derivatives
~~~~~~~~~~~~~~~~~~

First, download the package:

::

	$ curl -LO https://github.com/gportay/dosh/releases/download/9/dosh_9_all.deb

Then, install it using the package manager:

::

	$ sudo dpkg -i ./dosh_9_all.deb

*Note*: Uninstall it using the package manager:

::

	$ sudo dpkg -r dosh

RPM derivatives
~~~~~~~~~~~~~~~

First, download the package:

::

	$ curl -LO https://github.com/gportay/dosh/releases/download/9/dosh-9-1.noarch.rpm

Then, install it using the package manager:

::

	$ sudo dnf install ./dosh-9-1.noarch.rpm

*Note*: Uninstall it using the package manager:

::

	$ sudo dnf remove dosh

Sources
-------

Run one of the following commands to install *dosh(1)*.

To your home directory:

::

	$ make user-install

Or, to your system:

::

	$ sudo make install

The traditional variables *DESTDIR* and *PREFIX* can be overridden:

::

	$ sudo make install PREFIX=/opt/dosh

Or:

::

	$ make install DESTDIR=$PWD/pkg PREFIX=/usr
