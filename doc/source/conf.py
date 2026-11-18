# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'dosh'
copyright = '2026, Gaël PORTAY'
author = 'Gaël PORTAY'
release = '9'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = []

templates_path = ['_templates']
exclude_patterns = []

rst_epilog = '''
.. _Dockerfile: https://docs.docker.com/reference/dockerfile
.. _bash: https://www.gnu.org/software/bash/
.. _coreutils 8.30: https://github.com/coreutils/coreutils/commit/668306ed86c8c79b0af0db8b9c882654ebb66db2
.. _docker: https://github.com/docker/docker
.. _dosh(1): https://github.com/gportay/dosh/blob/master/dosh.1.adoc
.. _dosh: https://github.com/gportay/dosh/blob/master/dosh
.. _env(1): https://linux.die.net/man/1/env
.. _environment-variables: https://github.com/gportay/dosh/blob/master/dosh.1.adoc#environment-variables
.. _examples: https://github.com/gportay/dosh/blob/master/dosh.1.adoc#examples
.. _execve(2): https://linux.die.net/man/2/execve
.. _multi-platform: https://docs.docker.com/build/building/multi-platform/
.. _non-root-user: https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
.. _podman: https://github.com/containers/podman
.. _posh: https://github.com/gportay/dosh/blob/master/support/posh
.. _yadutaf: https://blog.yadutaf.fr/2017/09/10/running-a-graphical-app-in-a-docker-container-on-a-remote-server/
'''



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'alabaster'
html_static_path = ['_static']
