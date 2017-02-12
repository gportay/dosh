#!/bin/bash
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

set -e

run() {
	test="$@"
	echo -e "\e[1mRunning $test...\e[0m"
}

ok() {
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
}

ko() {
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
}

fix() {
	fix=$((fix+1))
	echo -e "\e[1m$test: \e[34m[FIX]\e[0m"
}

bug() {
	bug=$((bug+1))
	echo -e "\e[1m$test: \e[33m[BUG]\e[0m"
}

result() {
	echo -e "\e[1m\e[32m$ok test(s) succeed!\e[0m"

	if [ -n "$fix" ]; then
		echo -e "\e[1m\e[33m$fix test(s) fixed!\e[0m" >&2
	fi

	if [ -n "$bug" ]; then
		echo -e "\e[1mWarning: \e[33m$bug test(s) bug!\e[0m" >&2
	fi

	if [ -n "$ko" ]; then
		echo -e "\e[1mError: \e[31m$ko test(s) failed!\e[0m" >&2
		exit 1
	fi
}

PATH="$PWD:$PATH"
trap result 0

run "Test without option with arguments"
if          dsh "$@"  echo "one" "two" "three" | tee /dev/stderr | \
   diff - <($SHELL    echo "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -c without arguments"
if          dsh "$@"  -c | tee /dev/stderr | \
   diff - <($SHELL    -c | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -c with empty argument"
if          dsh "$@"  -c '' | tee /dev/stderr | \
   diff - <($SHELL    -c '' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -c command arguments"
if          dsh "$@"  -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr | \
   diff - <($SHELL    -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s without arguments"
if          echo 'whoami; echo "$0" "$#" "$@"' | dsh "$@" -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL   -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s one two three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dsh "$@"  -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL    -s "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s \"one + two\" three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dsh "$@"  -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL    -s "one + two" "three" | tee /dev/stderr )
then
	# See FIXME in dsh
	fix
else
	# See FIXME in dsh
	bug
fi
echo

run "Test option --root with arguments"
if                      dsh "$@"  --root echo "one" "two" "three" | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           echo "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --root and -c without arguments"
if                      dsh "$@"  --root -c | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           -c | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --root and -c with empty arguments"
if                      dsh "$@"  --root -c '' | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           -c '' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --root and -c command arguments"
if                      dsh "$@"  --root -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --root and -s without arguments"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dsh "$@"  --root -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL           -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --root and -s one two three"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dsh "$@"  --root -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL           -s "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --root and -s \"one + two\" three"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dsh "$@"  --root -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL           -s "one + two" "three" | tee /dev/stderr )
then
	# See FIXME in dsh
	fix
else
	# See FIXME in dsh
	bug
fi
echo

run "Test option -f"
if dsh "$@" -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "Test option -f"
if dsh "$@" -f Dockerfile.fedora -c "cat /etc/os*release" | tee /dev/stderr | \
	grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo

run "Test option -C with relative path"
if ( cd .. && dir="${OLDPWD##*/}" && \
     dsh "$@" -C "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "Test option -C with absolute path"
if ( cd /tmp && dir="$OLDPWD" && \
     dsh "$@" -C "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "Test option --home"
if          echo 'pwd; cd ; pwd' |             dsh "$@"  --home -s | tee /dev/stderr | \
   diff - <(echo 'pwd; cd ; pwd' | fakeroot -- $SHELL           -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test shebang"
if ./shebang.dsh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "Test shebang with arguments"
if ./shebang-fedora.dsh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo

run "Test --detach"
if container="$(dsh --detach)" && \
            docker rm -f "$container" | tee /dev/stderr | \
   diff - <(echo "$container"        | tee /dev/stderr )
then
	ok
else
	ko
fi
echo
