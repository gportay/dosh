.. SPDX-License-Identifier: LGPL-2.1-or-later

Links
=====

Check out the `man-pages <dosh(1)_>`_ and its `examples`_.

Also, here is an extra example that builds the documentation:

::

	$ mkdir docker
	$ echo "FROM ubuntu" >docker/Dockerfile
	$ echo "RUN apt-get update && apt-get install -y asciidoctor" >>docker/Dockerfile

	$ cat docker/Dockerfile
	FROM ubuntu
	RUN apt-get update && apt-get install -y asciidoctor

	$ dosh -c "asciidoctor -b manpage -o - dosh.1.adoc | gzip -c - >dosh.1.gz"
	#0 building with "default" instance using docker driver
	...

	$ man ./dosh.1.gz

Enjoy!
