#!/usr/bin/env -S DOSH_DOCKERFILE=Dockerfile.rpm DOSH_DOCKER_RUN_EXTRA_OPTS="--volume ${PWD}/rpmbuild:${HOME}/rpmbuild --volume ${PWD}/dosh.spec:${HOME}/rpmbuild/SPECS/dosh.spec" dosh
set -e
rpmdev-setuptree
cd ~/rpmbuild/SPECS
rpmbuild --undefine=_disable_source_fetch --define='_dockerlibdir %{_exec_prefix}/lib/docker' -ba dosh.spec "$@"
rpmlint ~/rpmbuild/SPECS/dosh.spec ~/rpmbuild/SRPMS/dosh*.rpm ~/rpmbuild/RPMS/dosh*.rpm
