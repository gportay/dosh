#!/bin/bash
#
# Copyright (c) 2017-2019 Gaël PORTAY
#
# SPDX-License-Identifier: MIT
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
	if [ -n "$EXIT_ON_ERROR" ]; then
		exit 1
	fi
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

export -n DOCKER
export -n DOSHELL
export -n DOSH_DOCKERFILE
export -n DOSH_DOCKER_BUILD_EXTRA_OPTS
export -n DOSH_DOCKER_RMI_EXTRA_OPTS
export -n DOSH_DOCKER_RUN_EXTRA_OPTS
export -n DOSH_DOCKER_EXEC_EXTRA_OPTS

rmi() {
	run "dosh: Test --rmi option"
	if   dosh --rmi &&
	   ! dosh --rmi
	then
		ok
	else
		ko
	fi
	echo

	run "dosh: Test --rmi option with --dockerfile option"
	if   dosh --rmi --dockerfile Dockerfile.fedora && \
	   ! dosh --rmi --dockerfile Dockerfile.fedora
	then
		ok
	else
		ko
	fi
	echo

	run "dosh: Test --rmi option with --directory and --dockerfile option in a busybox based distro"
	if ( cd .. && dir="${OLDPWD##*/}" && \
	       dosh --rmi --directory "$dir" --dockerfile Dockerfile.alpine && \
	     ! dosh --rmi --directory "$dir" --dockerfile Dockerfile.alpine )
	then
		ok
	else
		ko
	fi
	echo
}

if [ -n "$DO_CLEANUP" ]
then
	trap - 0
	rmi
	exit
fi

run "dosh: Test with missing Dockerfile"
if ! dosh --dockerfile Dockerfile.missing -c "echo Oops"
then
	ok
else
	ko
fi
echo

run "dosh: Test option --help"
if dosh --help | \
   grep '^Usage: '
then
	ok
else
	ko
fi
echo

run "dosh: Test option --version"
if dosh --version | \
   grep -E '^([0-9a-zA-Z]+)(\.[0-9a-zA-Z]+)*$'
then
	ok
else
	ko
fi
echo

run "dosh: Test option --build"
if dosh --build --verbose -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^Sending build context to Docker daemon'
then
	ok
else
	ko
fi
echo

run "dosh: Test option --rebuild"
if dosh --rebuild --verbose -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^Sending build context to Docker daemon'
then
	ok
else
	ko
fi
echo

run "dosh: Test DOSH_NOBUILD environment variable"
if ! DOSH_NOBUILD=1 dosh --build --verbose -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^Sending build context to Docker daemon'
then
	ok
else
	ko
fi
echo

run "dosh: Test with a binary argument"
if ! dosh "$@" echo "one" "two" "three"
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c without command"
if ! dosh "$@" -c
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c with empty command"
if          dosh "$@"  -c '' | tee /dev/stderr | \
   diff - <(/bin/sh    -c '' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c with commands"
if          dosh "$@"  -c 'whoami; echo "$#" "$@"' | tee /dev/stderr | \
   diff - <(/bin/sh    -c 'whoami; echo "$#" "$@"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -c with commands and arguments"
if          dosh "$@"  -c 'whoami; echo "$#" "$@"' 'unused' 'one' 'two' | tee /dev/stderr | \
   diff - <(/bin/sh    -c 'whoami; echo "$#" "$@"' 'unused' 'one' 'two' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s without arguments"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@" -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | /bin/sh   -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s one two three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@"  -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | /bin/sh    -s "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s one\ +\ two three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@"  -s one\ +\ two three | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | /bin/sh    -s one\ +\ two three | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option -s \"one + two\" three"
if          echo 'whoami; echo "$0" "$#" "$@"' | dosh "$@"  -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$0" "$#" "$@"' | /bin/sh    -s "one + two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --root"
if                      dosh "$@" --root -c 'whoami' | tee /dev/stderr | \
   diff - <(fakeroot -- /bin/sh          -c 'whoami' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --dind"
if dosh --shell /usr/bin/dosh --dind -c 'echo "DOSHLVL=$DOSHLVL"' | tee /dev/stderr | \
   grep -q 'DOSHLVL=2'
then
	ok
else
	ko
fi

run "dosh: Test option -c"
if dosh "$@" -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "dosh: Test \$DOSH_DOCKERFILE"
if DOSH_DOCKERFILE=Dockerfile.fedora \
   dosh "$@" -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo

run "dosh: Test option --dockerfile"
if dosh "$@" --dockerfile Dockerfile.fedora -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo

run "dosh: Test option --context"
tar cf context.tar Dockerfile dosh bash-completion support/* examples/*
if dosh "$@" --build --context context.tar -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo
rm context.tar

run "dosh: Test option --context with --dockerfile"
tar cf context.tar Dockerfile.fedora
if dosh "$@" --build --dockerfile Dockerfile.fedora --context context.tar -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 25 (Twenty Five)'
then
	ok
else
	ko
fi
echo
rm context.tar

run "dosh: Test option --directory with relative path"
if ( cd .. && dir="${OLDPWD##*/}" && \
     dosh "$@" --directory "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --directory with absolute path"
if ( cd /tmp && dir="$OLDPWD" && \
     dosh "$@" --directory "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --home"
if          echo 'pwd; cd ; pwd' | dosh "$@"  --home -s | tee /dev/stderr | \
   diff - <(echo 'pwd; cd ; pwd' | /bin/sh           -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test option --shell /bin/dash"
if          echo 'echo $0' | dosh "$@"  --shell /bin/dash -s | tee /dev/stderr | \
   diff - <(echo '/bin/dash'                                 | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test default shell"
if          echo 'echo $0' | dosh "$@"  -s | tee /dev/stderr | \
   diff - <(echo 'echo $0' | /bin/sh    -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test shebang (dind and bash)"
if dosh --shell /bin/bash --dind -c 'examples/shebang.dosh' | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 16.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "dosh: Test shebang with arguments (dind and bash)"
if dosh --shell /bin/bash --dind -c 'examples/shebang-fedora.dosh' | tee /dev/stderr | \
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

run "dosh: Test DOCKER environment variable"
if DOCKER="echo docker" dosh | tee /dev/stderr | \
   grep "docker run --rm --volume $PWD:$PWD --user $UID:${GROUPS[0]} --interactive --tty --workdir $PWD --env DOSHLVL=1 --entrypoint /bin/sh dosh-[0-9a-z]\{64\}"
then
	ok
else
	ko
fi
echo

run "dosh: Test with a busybox based distro (/bin/ash + adduser/addgroup)"
if DOSHELL=/bin/ash dosh --dockerfile Dockerfile.alpine --build "$@" -c "cat /etc/os*release"
then
	ok
else
	ko
fi
echo

run "dosh: Test DOSH_DOCKER_RUN_EXTRA_OPTS environment variable"
if DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $PWD:$HOME/.local/bin --env PATH=$HOME/.local/bin:/usr/bin" \
   dosh -c "which dosh" | grep "$HOME/.local/bin/dosh"
then
	ok
else
	ko
fi
echo

run "dosh: Test --no-extra-options option"
if DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $PWD:$HOME/.local/bin --env PATH=$HOME/.local/bin:/usr/bin" \
   dosh --no-extra-options -c "which dosh" | grep '/usr/bin/dosh'
then
	ok
else
	ko
fi
echo

run "dosh: Test --tag option"
if dosh --tag
then
	ok
else
	ko
fi
echo

run "dosh: Test --tag option with --dockerfile option"
if dosh --tag --dockerfile Dockerfile.fedora
then
	ok
else
	ko
fi
echo

run "dosh: Test --tag option with --directory and --dockerfile option in a busybox based distro"
if ( cd .. && dir="${OLDPWD##*/}" && dosh --tag )
then
	ok
else
	ko
fi
echo

run "dosh: Test when user is set in Dockerfile"
if dosh --dockerfile Dockerfile.user -c "whoami"
then
	ok
else
	ko
fi
echo

IFS=":" read -r -a did <<< "$(grep '^docker' /etc/group)"
sed -e "s,@USER@,$USER,g" \
    -e "s,@GROUP@,${GROUPS[0]},g" \
    -e "s,@UID@,$UID,g" \
    -e "s,@GID@,${GROUPS[0]},g" \
    -e "s,@HOME@,$HOME,g" \
    -e "s,@DID_GID@,${did[2]},g" \
    Dockerfile.me.in >Dockerfile.me

run "dosh: Test when user/group already exists with same UID/GID in Dockerfile"
if          dosh --rebuild --dockerfile Dockerfile.me -c 'echo "$(id -un):$(id -u):$(id -g)"' | tee /dev/stderr | \
   diff - <(/bin/sh                                   -c 'echo "$(id -un):$(id -u):$(id -g)"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo
rm -f Dockerfile.me

uid="$((UID+1))"
gid="$((${GROUPS[0]}+1))"
sed -e "s,@USER@,$USER,g" \
    -e "s,@GROUP@,${GROUPS[0]},g" \
    -e "s,@UID@,$uid,g" \
    -e "s,@GID@,$gid,g" \
    -e "s,@HOME@,$HOME,g" \
    -e "s,@DID_GID@,${did[2]},g" \
    Dockerfile.me.in >Dockerfile.not-me
cat Dockerfile.not-me

run "dosh: Test when user/group already exists with different UID/GID in Dockerfile"
if          dosh --rebuild --dockerfile Dockerfile.not-me -c 'echo "$(id -un):$(id -u):$(id -g)"' | tee /dev/stderr | \
   diff - <(/bin/sh                                       -c 'echo "$(id -u ):$(id -u):$(id -g)"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo
rm -f Dockerfile.not-me

run "dosh: Test with shopt arguments using /bin/bash (dind)"
if          dosh --shell /usr/bin/dosh --dind -- --shell /bin/bash -- +B -x -o errexit +h -c 'echo "$-"; echo "$BASHOPTS"; shopt -s' | tee /dev/stderr | \
   diff - <(dosh                                 --shell /bin/bash    +B -x -o errexit +h -c 'echo "$-"; echo "$BASHOPTS"; shopt -s' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "dosh: Test without pipefail bashopt argument"
if dosh --shell /bin/bash -c 'false | true'
then
	ok
else
	ko
fi
echo

run "dosh: Test with pipefail bashopt argument"
if ! dosh --shell /bin/bash -o pipefail -c 'false | true'
then
	ok
else
	ko
fi
echo

if [ -n "$DO_RMI_TESTS" ]
then
	rmi
else
	cat <<EOF >&2
Note: --rmi tests are disabled by default!
      Set DO_RMI_TESTS=1 to enable --rmi tests.

EOF
fi
