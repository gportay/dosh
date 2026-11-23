#!/usr/bin/env -S DOSH_DOCKERFILE=docker/brew/Dockerfile dosh --no-doshrc
set -e
brew tap-new --no-git gportay/dosh
cp Formula/dosh.rb "$(brew --repository gportay/dosh)/Formula/dosh.rb"
brew install --build-bottle gportay/dosh/dosh "$@"
brew test gportay/dosh/dosh
brew audit --strict gportay/dosh/dosh
brew bottle gportay/dosh/dosh
