.. SPDX-License-Identifier: LGPL-2.1-or-later

Use as interpreter for shell scripts
====================================

`dosh(1)`_ can be used as an interpreter for shell scripts.

According to `execve(2)`_:

   Interpreter scripts

   An interpreter script is a text file that has execute permission enabled
   and whose first line is of the form:

   ::

	#!interpreter [optional-arg]

   The interpreter must be a valid pathname for an executable file.

   If the pathname argument of execve() specifies an interpreter script, then
   interpreter will be invoked with the following arguments:

   ::

	interpreter [optional-arg] pathname arg...

   where pathname is the pathname of the file specified as the first argument
   of execve(), and arg... is the series of words pointed to by the argv
   argument of execve(), starting at argv[1]. Note that there is no way to get
   the argv[0] that was passed to the execve() call.

   For portable use, optional-arg should either be absent, or be specified as a
   single word (i.e., it should not contain white space); see NOTES below.

   Since Linux 2.6.28, the kernel permits the interpreter of a script to itself
   be a script. This permission is recursive, up to a limit of four recursions,
   so that the interpreter may be a script which is interpreted by a script,
   and so on.

   Notes

   Linux ignores the set-user-ID and set-group-ID bits on scripts.

   A maximum line length of 127 characters is allowed for the first line in a
   #! executable shell script.

   The semantics of the optional-arg argument of an interpreter script vary
   across implementations. On Linux, the entire string following the
   interpreter name is passed as a single argument to the interpreter, and this
   string can include white space. However, behavior differs on some other
   systems. Some systems use the first white space to terminate optional-arg.
   On some systems, an interpreter script can have multiple arguments, and
   white spaces in optional-arg are used to delimit the arguments.

A typical shebang to run a shell script via *dosh* is ``#!/usr/bin/dosh``.

However, the absolute path to *dosh* is unpredictable since it may be installed
in ``/bin``, ``/usr/bin``, ``/usr/local/bin``, in the user home
``~/.local/bin``, or even in ``/opt``.

Therefore, the most appropriate shebang to run *dosh* is
``#!/usr/bin/env dosh``.

Additionally, consider using the `env(1)`_ split option ``-S`` (since
`coreutils 8.30`_) when passing *dosh* arguments, such as
``#!/usr/bin/env -S dosh --home``.

*Important*: *dosh* warns and splits the list of arguments itself when using
the absolute path (i.e. ``#!/usr/bin/dosh --dockerfile docker/Dockerfile``)
instead of *env* and its split option (i.e.
``#!/usr/bin/env -S dosh --dockerfile docker/Dockerfile``). This feature is not
portable; it is deprecated since version 7 and is scheduled for removal in a
future release. Consider moving the shebang to `env(1)`_ and its ``-S``
option, available since mid-`2018 <coreutils 8.30_>`_.
