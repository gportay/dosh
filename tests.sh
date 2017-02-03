#!/bin/bash
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
#

set -e

PATH="$PWD:$PATH"

test="Test without option with arguments"
echo -e "\e[1mRunning $test...\e[0m"
if          dsh "$@"  echo "one" "two" "three" | tee /dev/stderr | \
   diff - <($SHELL    echo "one" "two" "three" | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -c without arguments"
echo -e "\e[1mRunning $test...\e[0m"
if          dsh "$@"  -c | tee /dev/stderr | \
   diff - <($SHELL    -c | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -c without arguments"
echo -e "\e[1mRunning $test...\e[0m"
if          dsh "$@"  -c '' | tee /dev/stderr | \
   diff - <($SHELL    -c '' | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -c command arguments"
echo -e "\e[1mRunning $test...\e[0m"
if          dsh "$@"  -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr | \
   diff - <($SHELL    -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -s without arguments"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'whoami; echo "$0" "$#" "$@"' | dsh "$@" -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL   -s | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -s one two three"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'whoami; echo "$0" "$#" "$@"' | dsh "$@"  -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL    -s "one" "two" "three" )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -s \"one + two\" three"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'whoami; echo "$0" "$#" "$@"' | dsh "$@"  -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | $SHELL    -s "one + two" "three" | tee /dev/stderr )
then
	# See FIXME in dsh
	# ok=$((ok+1))
	fix=$((fix+1))
	echo -e "\e[1m$test: \e[34m[FIX]\e[0m"
else
	# See FIXME in dsh
	# ko=$((ko+1))
	bug=$((bug+1))
	echo -e "\e[1m$test: \e[33m[BUG]\e[0m"
fi
echo

test="Test option --root with arguments"
echo -e "\e[1mRunning $test...\e[0m"
if                      dsh "$@"  --root echo "one" "two" "three" | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           echo "one" "two" "three" | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --root and -c without arguments"
echo -e "\e[1mRunning $test...\e[0m"
if                      dsh "$@"  --root -c | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           -c | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --root and -c with empty arguments"
echo -e "\e[1mRunning $test...\e[0m"
if                      dsh "$@"  --root -c '' | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           -c '' | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --root and -c command arguments"
echo -e "\e[1mRunning $test...\e[0m"
if                      dsh "$@"  --root -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr | \
   diff - <(fakeroot -- $SHELL           -c 'whoami; echo "$#" "$@" "one" "two" "three"' | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --root and -s without arguments"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dsh "$@"  --root -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL           -s | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --root and -s one two three"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dsh "$@"  --root -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL           -s "one" "two" "three" | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --root and -s \"one + two\" three"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'whoami; echo "$0" "$#" "$@"' |             dsh "$@"  --root -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | fakeroot -- $SHELL           -s "one + two" "three" | tee /dev/stderr )
then
	# See FIXME in dsh
	# ok=$((ok+1))
	fix=$((fix+1))
	echo -e "\e[1m$test: \e[34m[FIX]\e[0m"
else
	# See FIXME in dsh
	# ko=$((ko+1))
	bug=$((bug+1))
	echo -e "\e[1m$test: \e[33m[BUG]\e[0m"
fi
echo

test="Test option -f"
echo -e "\e[1mRunning $test...\e[0m"
if dsh "$@" -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -f"
echo -e "\e[1mRunning $test...\e[0m"
if dsh "$@" -f Dockerfile.fedora -c "cat /etc/os*release" | tee /dev/stderr | \
	grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -C with relative path"
echo -e "\e[1mRunning $test...\e[0m"
if ( cd .. && dir="${OLDPWD##*/}" && \
     dsh "$@" -C "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option -C with absolute path"
echo -e "\e[1mRunning $test...\e[0m"
if ( cd /tmp && dir="$OLDPWD" && \
     dsh "$@" -C "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test option --home"
echo -e "\e[1mRunning $test...\e[0m"
if          echo 'pwd; cd ; pwd' |             dsh "$@"  --home -s | tee /dev/stderr | \
   diff - <(echo 'pwd; cd ; pwd' | fakeroot -- $SHELL           -s | tee /dev/stderr )
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test shebang"
echo -e "\e[1mRunning $test...\e[0m"
if ./shebang.dsh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

test="Test shebang with arguments"
echo -e "\e[1mRunning $test...\e[0m"
if ./shebang-fedora.dsh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
else
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
fi
echo

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

echo -e "\e[1m\e[32m$ok test(s) succeed!\e[0m"
