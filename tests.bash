#!/bin/bash
#
# Copyright 2017-2020,2023-2025 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

set -e
set -o pipefail

run() {
	lineno="${BASH_LINENO[0]}"
	test="$*"
	echo -e "\e[1mRunning $test...\e[0m"
}

ok() {
	ok=$((ok+1))
	echo -e "\e[1m$test: \e[32m[OK]\e[0m"
}

ko() {
	ko=$((ko+1))
	echo -e "\e[1m$test: \e[31m[KO]\e[0m"
	reports+=("$test at line \e[1m$lineno \e[31mhas failed\e[0m!")
	if [[ $EXIT_ON_ERROR ]]
	then
		exit 1
	fi
}

fix() {
	fix=$((fix+1))
	echo -e "\e[1m$test: \e[34m[FIX]\e[0m"
	reports+=("$test at line \e[1m$lineno is \e[34mfixed\e[0m!")
}

bug() {
	bug=$((bug+1))
	echo -e "\e[1m$test: \e[33m[BUG]\e[0m"
	reports+=("$test at line \e[1m$lineno is \e[33mbugged\e[0m!")
}

result() {
	exitcode="$?"
	trap - 0

	echo -e "\e[1mTest report:\e[0m"
	for report in "${reports[@]}"
	do
		echo -e "$report" >&2
	done

	if [[ $ok ]]
	then
		echo -e "\e[1m\e[32m$ok test(s) succeed!\e[0m"
	fi

	if [[ $fix ]]
	then
		echo -e "\e[1m\e[34m$fix test(s) fixed!\e[0m" >&2
	fi

	if [[ $bug ]]
	then
		echo -e "\e[1mWarning: \e[33m$bug test(s) bug!\e[0m" >&2
	fi

	if [[ $ko ]]
	then
		echo -e "\e[1mError: \e[31m$ko test(s) failed!\e[0m" >&2
	fi

	if [[ $exitcode -ne 0 ]] && [[ $ko ]]
	then
		echo -e "\e[1;31mExited!\e[0m" >&2
	elif [[ $exitcode -eq 0 ]] && [[ $ko ]]
	then
		exit 1
	fi

	exit "$exitcode"
}

XDG_CACHE_HOME="$PWD/cache"
export XDG_CACHE_HOME

PATH="$PWD:$PATH"
trap result 0 SIGINT

export -n DOSH_DOCKER
export -n DOSH_DOCKER_HOST
export -n DOSHELL
export -n DOSH_DOCKERFILE
export -n DOSH_DOCKER_BUILD_EXTRA_OPTS
export -n DOSH_DOCKER_RMI_EXTRA_OPTS
export -n DOSH_DOCKER_RUN_EXTRA_OPTS
export -n DOSH_DOCKER_EXEC_EXTRA_OPTS

no_doshprofile=1
no_doshrc=1

export no_doshprofile
export no_doshrc

docker=(docker)
if "${docker[@]}" info -f "{{println .SecurityOptions}}" | grep -q rootless
then
	DOSH_DOCKER_HOST="${DOCKER_HOST:-unix://$XDG_RUNTIME_DIR/docker.sock}"

	export DOSH_DOCKER_HOST
elif ! grep -q -w docker < <(groups)
then
	docker=(sudo "${docker[@]}")
	sudo=1

	export sudo
fi

rmi() {
	run "Test --rmi option"
	if   dosh --rmi &&
	   ! dosh --rmi
	then
		ok
	else
		ko
	fi
	echo

	run "Test --rmi option with --dockerfile option"
	if   dosh --rmi --dockerfile Dockerfile.fedora && \
	   ! dosh --rmi --dockerfile Dockerfile.fedora
	then
		ok
	else
		ko
	fi
	echo

	run "Test --rmi option with --directory and --dockerfile option in a busybox based distro"
	if ( cd .. && dir="${OLDPWD##*/}" && \
	       dosh --rmi --directory "$dir" --dockerfile Dockerfile.alpine && \
	     ! dosh --rmi --directory "$dir" --dockerfile Dockerfile.alpine )
	then
		ok
	else
		ko
	fi
	echo

	rmdir "$XDG_CACHE_HOME/dosh"
	rmdir "$XDG_CACHE_HOME"
}

if [[ $DO_CLEANUP ]]
then
	trap - 0 SIGINT
	rmi
	exit
fi

run "Test with missing Dockerfile"
if ! dosh --dockerfile Dockerfile.missing -c "echo Oops"
then
	ok
else
	ko
fi
echo

run "Test option --help"
if dosh --help | tee /dev/stderr | \
   grep -q '^Usage: '
then
	ok
else
	ko
fi
echo

run "Test option --version"
if dosh --version | tee /dev/stderr | \
   grep -qE '^([0-9a-zA-Z]+)(\.[0-9a-zA-Z]+)*$'
then
	ok
else
	ko
fi
echo

run "Test option --dry-run"
if dosh --dry-run 2>&1 | tee /dev/stderr | \
   grep -q "${docker[*]} run --rm --volume $PWD:$PWD:rw --user $UID:${GROUPS[0]} --env USER=$USER --env HOME=$HOME --interactive --workdir $PWD --env DOSHLVL=1 --entrypoint /bin/sh dosh-$USER-[0-9a-z]\{64\}"
then
	ok
else
	ko
fi
echo

run "Test option --build-only"
if dosh --build-only -c "exit 1"
then
	ok
else
	ko
fi
echo

run "Test option --build"
if dosh --build --verbose -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^#0 building with "\w\+" instance using docker driver$'
then
	ok
else
	ko
fi
echo

run "Test option --rebuild"
if dosh --rebuild --verbose -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^#0 building with "\w\+" instance using docker driver$'
then
	ok
else
	ko
fi
echo

run "Test DOSH_NOBUILD environment variable"
if ! DOSH_NOBUILD=1 dosh --build --verbose -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^#0 building with "\w\+" instance using docker driver$'
then
	ok
else
	ko
fi
echo

run "Test with a binary argument"
if ! dosh echo "one" "two" "three"
then
	ok
else
	ko
fi
echo

run "Test option -c without command"
if ! dosh -c
then
	ok
else
	ko
fi
echo

run "Test option -c with empty command"
if          dosh -c '' | tee /dev/stderr | \
   diff - <(sh   -c '' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -c with commands"
if          dosh -c 'whoami; echo "$#" "$@"' | tee /dev/stderr | \
   diff - <(sh   -c 'whoami; echo "$#" "$@"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -c with commands and arguments"
if          dosh -c 'whoami; echo "$#" "$@"' 'unused' 'one' 'two' | tee /dev/stderr | \
   diff - <(sh   -c 'whoami; echo "$#" "$@"' 'unused' 'one' 'two' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s without arguments"
if          echo 'whoami; echo "$#" "$@"' | dosh -s | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$#" "$@"' | sh   -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s one two three"
if          echo 'whoami; echo "$#" "$@"' | dosh -s "one" "two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$#" "$@"' | sh   -s "one" "two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s one\ +\ two three"
if          echo 'whoami; echo "$#" "$@"' | dosh -s one\ +\ two three | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$#" "$@"' | sh   -s one\ +\ two three | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option -s \"one + two\" three"
if          echo 'whoami; echo "$#" "$@"' | dosh -s "one + two" "three" | tee /dev/stderr | \
   diff - <(echo 'whoami; echo "$#" "$@"' | sh   -s "one + two" "three" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --sudo"
if DOSH_SUDO="echo sudo" dosh --sudo | tee /dev/stderr | \
   grep -q "sudo docker run --rm --volume $PWD:$PWD:rw --user $UID:${GROUPS[0]} --env USER=$USER --env HOME=$HOME --interactive --tty --workdir $PWD --env DOSHLVL=1 --entrypoint /bin/sh dosh-$USER-[0-9a-z]\{64\}"

then
	ok
else
	ko
fi
echo

run "Test option --root"
if                      dosh --root -c 'whoami' | tee /dev/stderr | \
   diff - <(fakeroot -- sh          -c 'whoami' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --dind"
if dosh --shell /usr/bin/dosh --dind -c 'echo "DOSHLVL=$DOSHLVL"' | tee /dev/stderr | \
   grep -q 'DOSHLVL=2'
then
	ok
else
	ko
fi

run "Test option --groups"
if          echo 'echo ${GROUPS[@]}' | dosh --shell /bin/bash --groups -s | tee /dev/stderr | \
   diff - <(echo 'echo ${GROUPS[@]}' | bash                            -s | tee /dev/stderr )
then
	ok
else
	ko
fi

run "Test option -c"
if dosh -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 20.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "Test \$DOSH_DOCKERFILE"
if DOSH_DOCKERFILE=Dockerfile.fedora \
   dosh -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 29 (Container Image)"'
then
	ok
else
	ko
fi
echo

run "Test option --dockerfile"
if dosh --dockerfile Dockerfile.fedora -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 29 (Container Image)"'
then
	ok
else
	ko
fi
echo

run "Test option --context"
tar cf context.tar Dockerfile dosh bash-completion support/* examples/*
if dosh --build --context context.tar -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 20.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo
rm context.tar

run "Test option --context with --dockerfile"
tar cf context.tar Dockerfile.fedora
if dosh --build --dockerfile Dockerfile.fedora --context context.tar -c "cat /etc/os*release" | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 29 (Container Image)"'
then
	ok
else
	ko
fi
echo
rm context.tar

run "Test option --no-auto-context"
if dosh --build --no-auto-context -c "cat /etc/os*release" 2>&1 >/dev/null | tee /dev/stderr | \
   grep '^Info: ADD or COPY instructions sends build context to daemon.'
then
	ok
else
	ko
fi
echo

run "Test option --working-directory with current directory (relative path)"
if ( dosh --working-directory . -c "pwd" | tee /dev/stderr | \
     grep -q "^$PWD$" )
then
	ok
else
	ko
fi
echo

run "Test option --working-directory with parent directory (relative path)"
if ( dosh --working-directory .. -c "pwd" | tee /dev/stderr | \
     grep -q "^${PWD%/*}$" )
then
	ok
else
	ko
fi
echo

run "Test option --working-directory with root directory (absolute path)"
if ( dosh --working-directory / -c "pwd" | tee /dev/stderr | \
     grep -q '^/$' )
then
	ok
else
	ko
fi
echo

run "Test option --working-directory with home directory (absolute path)"
if ( dosh --working-directory "$HOME" -c "pwd" | tee /dev/stderr | \
     grep -q "^$HOME$" )
then
	ok
else
	ko
fi
echo

run "Test option --working-directory with unexistent directory"
if ( dosh --working-directory "/opt/dosh" -c "pwd" | tee /dev/stderr | \
     grep -q "^/opt/dosh$" )
then
	ok
else
	ko
fi
echo

run "Test option --directory with relative path"
if ( cd .. && dir="${OLDPWD##*/}" && \
     dosh --directory "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 20.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "Test option --directory with absolute path"
if ( cd /tmp && dir="$OLDPWD" && \
     dosh --directory "$dir" -c "cat /etc/os*release" | tee /dev/stderr | \
     grep -q 'PRETTY_NAME="Ubuntu 20.04[.0-9]* LTS"' )
then
	ok
else
	ko
fi
echo

run "Test option --home"
if          echo 'pwd; cd; pwd' | dosh --home -s | tee /dev/stderr | \
   diff - <(echo 'pwd; cd; pwd' | sh          -s | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --mount-options"
if dosh --dry-run --mount-options ro 2>&1 | tee /dev/stderr | \
   grep -q "${docker[*]} run --rm --volume $PWD:$PWD:ro --user $UID:${GROUPS[0]} --env USER=$USER --env HOME=$HOME --interactive --workdir $PWD --env DOSHLVL=1 --entrypoint /bin/sh dosh-$USER-[0-9a-z]\{64\}"
then
	ok
else
	ko
fi
echo

run "Test option --mount-options (run-time)"
if ! dosh --mount-options ro -c "touch read-only" 2>&1 | tee /dev/stderr |
   grep -q "^touch: .*: Read-only file system\$"
then
	ok
else
	ko
fi
echo

run "Test option --shell /bin/dash"
if          echo 'echo $0' | dosh --shell /bin/dash -s | tee /dev/stderr | \
   diff - <(echo '/bin/dash'                           | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test default shell"
if          echo 'echo $0' | dosh -s | tee /dev/stderr | \
   diff - <(echo '/bin/sh'           | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test shebang (dind and bash)"
if dosh --shell /bin/bash --dind -c 'examples/shebang.dosh' | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Ubuntu 20.04[.0-9]* LTS"'
then
	ok
else
	ko
fi
echo

run "Test shebang with arguments (dind and bash)"
if dosh --shell /bin/bash --dind -c 'examples/shebang-fedora.dosh' | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 29 (Container Image)"'
then
	ok
else
	ko
fi
echo

run "Test shebang using env"
if examples/shebang-env.dosh | tee /dev/stderr | \
   grep -q 'PRETTY_NAME="Fedora 29 (Container Image)"'
then
	ok
else
	ko
fi
echo

run "Test options --detach and --exec"
if container="$(dosh --detach)" && \
   dosh --exec "$container"  -c "hostname" | tee /dev/stderr | \
   diff - <(echo "${container:0:12}"       | tee /dev/stderr ) && \
   "${docker[@]}" rm -f "$container"       | tee /dev/stderr | \
   diff - <(echo "$container"              | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test option --exec without --working-directory"
if container="$(dosh --detach)" && \
   dosh --exec "$container"  -c 'pwd' | tee /dev/stderr | \
   diff - <(echo "$PWD"               | tee /dev/stderr ) && \
   "${docker[@]}" rm -f "$container"
then
	ok
else
	ko
fi
echo

run "Test options --exec and --working-directory with home directory"
if container="$(dosh --detach)" && \
   dosh --exec "$container" --working-directory "$HOME"  -c 'pwd' | tee /dev/stderr | \
   diff - <(echo "$HOME"                                          | tee /dev/stderr ) && \
   "${docker[@]}" rm -f "$container"
then
	ok
else
	ko
fi
echo

run "Test option --exec and DOSHLVL environment variable"
if container="$(dosh --detach)" && \
   DOSHLVL="1" dosh --exec "$container" --working-directory "$HOME"  -c 'echo "DOSHLVL=$DOSHLVL"' | tee /dev/stderr | \
   diff - <(echo "DOSHLVL=2"                                                                      | tee /dev/stderr ) && \
   "${docker[@]}" rm -f "$container"
then
	ok
else
	ko
fi
echo

run "Test DOSHLVL environment variable"
if DOSHLVL="1" dosh  -c 'echo "DOSHLVL=$DOSHLVL"' | tee /dev/stderr | \
   diff - <(echo "DOSHLVL=2"                      | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test DOSH_DOCKER environment variable"
if DOSH_DOCKER="echo docker" dosh | tee /dev/stderr | \
   grep -q "docker run --rm --volume $PWD:$PWD:rw --user $UID:${GROUPS[0]} --env USER=$USER --env HOME=$HOME --interactive --tty --workdir $PWD --env DOSHLVL=1 --entrypoint /bin/sh dosh-$USER-[0-9a-z]\{64\}"
then
	ok
else
	ko
fi
echo

run "Test with a busybox based distro (/bin/ash + adduser/addgroup)"
if DOSHELL=/bin/ash dosh --dockerfile Dockerfile.alpine --build -c "cat /etc/os*release"
then
	ok
else
	ko
fi
echo

run "Test DOSH_DOCKER_RUN_EXTRA_OPTS environment variable"
if DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $PWD:$HOME/.local/bin --env PATH=$HOME/.local/bin:/usr/bin" \
   dosh -c "which dosh" | grep "$HOME/.local/bin/dosh"
then
	ok
else
	ko
fi
echo

run "Test DOSH_DOCKER_RUN_EXTRA_OPTS environment variable with whitespace"
if DOSH_DOCKER_RUN_EXTRA_OPTS="--env FOO=bar\ baz" dosh -c env 2>&1 | tee /dev/stderr | \
   grep -q "^FOO=bar baz$"
then
	ok
else
	ko
fi
echo

run "Test DOSH_DOCKER_RUN_EXTRA_OPTS environment variable with echo short option -e"
if DOSH_DOCKER_RUN_EXTRA_OPTS="-e ECHO_SHORT_OPTION=true" dosh --dry-run 2>&1 | tee /dev/stderr | \
   grep -q "${docker[*]} run --rm --volume $PWD:$PWD:rw --user $UID:${GROUPS[0]} --env USER=$USER --env HOME=$HOME --interactive --workdir $PWD --env DOSHLVL=1 --entrypoint /bin/sh -e ECHO_SHORT_OPTION=true dosh-$USER-[0-9a-z]\{64\}"
then
	ok
else
	ko
fi
echo

run "Test --no-extra-options option"
if DOSH_DOCKER_RUN_EXTRA_OPTS="--volume $PWD:$HOME/.local/bin --env PATH=$HOME/.local/bin:/usr/bin" \
   dosh --no-extra-options -c "which dosh" | grep '/usr/bin/dosh'
then
	ok
else
	ko
fi
echo

run "Test --tag option"
if dosh --tag | tee /dev/stderr | \
   grep -q "^dosh-$USER-[0-9a-z]\{64\}$"
then
	ok
else
	ko
fi
echo

run "Test --tag option with username docker"
if USER=docker dosh --tag | tee /dev/stderr | \
   grep -q "^dosh-docker-[0-9a-z]\{64\}$"
then
	ok
else
	ko
fi
echo

run "Test --tag option with username dosh@portay.io to sanitize"
if USER=dosh@portay.io dosh --tag | tee /dev/stderr | \
   grep -q "^dosh-dosh_portay.io-[0-9a-z]\{64\}$"
then
	ok
else
	ko
fi
echo

run "Test --tag option with --dockerfile option"
if dosh --tag --dockerfile Dockerfile.fedora | tee /dev/stderr | \
   grep -q "^dosh-$USER-[0-9a-z]\{64\}$"
then
	ok
else
	ko
fi
echo

run "Test --tag option with --directory and --dockerfile option in a busybox based distro"
if ( cd .. && dir="${OLDPWD##*/}" && \
     dosh --tag --directory "$dir" --dockerfile Dockerfile.alpine | tee /dev/stderr | \
     grep -q "^dosh-$USER-[0-9a-z]\{64\}$" )
then
	ok
else
	ko
fi
echo

run "Test tags are identical when Dockerfiles are identicals"
if          dosh --tag                                | tee /dev/stderr | \
   diff - <(dosh --tag --dockerfile "$PWD/Dockerfile" | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test tags are different when Dockerfiles are differents"
if !        dosh --tag                                | tee /dev/stderr | \
   diff - <(dosh --tag --dockerfile Dockerfile.fedora | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test when user is set in Dockerfile"
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

run "Test when user/group already exists with same UID/GID in Dockerfile"
if          dosh --rebuild --dockerfile Dockerfile.me -c 'echo "$(id -un):$(id -u):$(id -g)"' | tee /dev/stderr | \
   diff - <(/bin/sh                                   -c 'echo "$(id -un):$(id -u):$(id -g)"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test USER and HOME are set to user's values"
if          dosh --rebuild --dockerfile Dockerfile.me -c 'echo "$USER:$HOME"' | tee /dev/stderr | \
   diff - <(sh                                        -c 'echo "$USER:$HOME"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test --rmi option"
if   DOSH_DOCKERFILE=Dockerfile.me \
     dosh --rmi
then
	ok
else
	ko
fi
echo
rm -f Dockerfile.me

uid="$((UID+1))"
gid="$((GROUPS[0]+1))"
sed -e "s,@USER@,$USER,g" \
    -e "s,@GROUP@,${GROUPS[0]},g" \
    -e "s,@UID@,$uid,g" \
    -e "s,@GID@,$gid,g" \
    -e "s,@HOME@,$HOME,g" \
    -e "s,@DID_GID@,${did[2]},g" \
    Dockerfile.me.in >Dockerfile.not-me
cat Dockerfile.not-me

run "Test when user/group already exists with different UID/GID in Dockerfile"
if          dosh --rebuild --dockerfile Dockerfile.not-me -c 'echo "$(id -un):$(id -u):$(id -g)"' | tee /dev/stderr | \
   diff - <(sh                                            -c 'echo "$(id -u ):$(id -u):$(id -g)"' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test --rmi option with --dockerfile option"
if   dosh --rmi --dockerfile Dockerfile.not-me
then
	ok
else
	ko
fi
echo
rm -f Dockerfile.not-me

run "Test with shopt arguments using /bin/bash (dind)"
if          dosh --shell /usr/bin/dosh --dind -- --shell /bin/bash -- +B -x -o errexit +h -c 'echo "$-"; echo "$BASHOPTS"; shopt -s' | tee /dev/stderr | \
   diff - <(dosh                                 --shell /bin/bash    +B -x -o errexit +h -c 'echo "$-"; echo "$BASHOPTS"; shopt -s' | tee /dev/stderr )
then
	ok
else
	ko
fi
echo

run "Test without pipefail bashopt argument"
if dosh --shell /bin/bash -c 'false | true'
then
	ok
else
	ko
fi
echo

run "Test with pipefail bashopt argument"
if ! dosh --shell /bin/bash -o pipefail -c 'false | true'
then
	ok
else
	ko
fi
echo

run "Test specific bash options (short form)"
if DOSHELL=/bin/bash dosh -p -c 'echo "$-"'
then
	ok
else
	ko
fi
echo

run "Test specific dash options (short form)"
if DOSHELL=/bin/dash dosh -p -c 'echo "$-"'
then
	ok
else
	ko
fi
echo

run "Test specific zsh options (short form)"
if DOSHELL=/bin/zsh dosh -p -c 'echo "$-"'
then
	ok
else
	ko
fi
echo

run "Test specific bash options (complete form)"
if DOSHELL=/bin/bash dosh -O compat31 -c 'shopt compat31 | grep on'
then
	ok
else
	ko
fi
echo

run "Test specific bash options (optional argument)"
if DOSHELL=/bin/bash dosh +O < <(echo whoami)
then
	ok
else
	ko
fi
echo

run "Test series of short options"
if dosh -ec 'echo "$-"' | tee /dev/stderr | grep 'e'
then
	ok
else
	ko
fi
echo

run "Test series of short options ending with option"
if dosh -co errexit 'echo "$-"' | tee /dev/stderr | grep 'e'
then
	ok
else
	ko
fi
echo

run "Test --ls option"
if dosh --ls
then
	ok
else
	ko
fi
echo

if [[ $DO_RMI_TESTS ]]
then
	rmi
else
	cat <<EOF >&2
Note: --rmi tests are disabled by default!
      Set DO_RMI_TESTS=1 to enable --rmi tests.

EOF
fi
