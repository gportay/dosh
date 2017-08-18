#!/bin/bash
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

set -e

run() {
	id=$((id+1))
	test="#$id: $@"
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
	if [ -n "$ok" ]; then
		echo -e "\e[1m\e[32m$ok test(s) succeed!\e[0m"
	fi

	if [ -n "$fix" ]; then
		echo -e "\e[1m\e[34m$fix test(s) fixed!\e[0m" >&2
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

run "dosh: Test without option with arguments"
if          dosh "$@"  echo "one" "two" "three" | tee /dev/stderr | \
   diff - <($SHELL     echo "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c without arguments"
if          dosh "$@"  -c | tee /dev/stderr | \
   diff - <($SHELL     -c | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c with empty argument"
if          dosh "$@"  -c '' | tee /dev/stderr | \
   diff - <($SHELL     -c '' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c command arguments"
if          dosh "$@"  -c 'whoami; echo "$#" "$@"' | tee /dev/stderr | \
   diff - <($SHELL     -c 'whoami; echo "$#" "$@"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s without arguments"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@" -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL    -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s one two three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@"  -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL     -s "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s one\ +\ two three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@"  -s one\ +\ two three | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL     -s one\ +\ two three | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s \"one + two\" three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@"  -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL     -s "one + two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root with arguments"
if                      dosh "$@"  --root echo "one" "two" "three" | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL            echo "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -c without arguments"
if                      dosh "$@"  --root -c | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL            -c | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -c with empty arguments"
if                      dosh "$@"  --root -c '' | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL            -c '' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -c command arguments"
if                      dosh "$@"  --root -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL            -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -s without arguments"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dosh "$@"  --root -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL            -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -s one two three"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dosh "$@"  --root -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL            -s "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -s one\ +\ two three"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dosh "$@"  --root -s one\ +\ two three | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL            -s one\ +\ two three | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root and -s \"one + two\" three"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dosh "$@"  --root -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL            -s "one + two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -f"
if dosh "$@" -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "dosh: Test option -F"
if dosh "$@" -F Dockerfile.fedora -c "cat /etc/os*release" | tee /dev/stderr | \
	grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo

run "dosh: Test option -C with relative path"
if ( cd .. && dir="${OLDPWD##*/}" && \
     dosh "$@" -C "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -C with absolute path"
if ( cd /tmp && dir="$OLDPWD" && \
     dosh "$@" -C "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --home"
if          echo 'pwd; cd ; pwd' |             dosh "$@"  --home -s | tee /dev/stderr | \
   diff - <(echo 'pwd; cd ; pwd' | fakeroot -- $SHELL            -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --sh"
if          echo 'echo $0' | dosh "$@"  --sh -s | tee /dev/stderr | \
   diff - <(echo 'echo $0' | /bin/sh         -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test default shell"
if          echo 'echo $0' | dosh "$@"  -s | tee /dev/stderr | \
   diff - <(echo 'echo $0' | $SHELL     -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test shebang"
if ./shebang.dosh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "dosh: Test shebang with arguments"
if ./shebang-fedora.dosh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo

run "dosh: Test --detach/--exec ID"
if container="$(dosh --detach)" && \
          dosh "$@" --exec "$container"  -c "hostname" | tee /dev/stderr | \
   diff - <(echo "${container:0:12}"                   | tee /dev/stderr ) && \
            docker rm -f "$container" | tee /dev/stderr | \
   diff - <(echo "$container"         | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test with a busybox based distro (/bin/ash + adduser/addgroup)"
if SHELL=/bin/ash dosh -F Dockerfile.alpine --build "$@" -c "cat /etc/os*release"
then
	ok
else
	ko
fi
echo

