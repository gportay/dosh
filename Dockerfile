FROM ubuntu:16.04
RUN apt-get update && apt-get install -y asciidoctor
RUN apt-get update && apt-get install -y docker.io
RUN apt-get update && apt-get install -y sudo make fakeroot bash-completion zsh wget
RUN wget -O /etc/zsh/zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
ADD dosh /usr/bin/
ADD bash-completion /usr/share/bash-completion/completions/dosh
ADD support/* /usr/share/dosh/support/
ADD examples/* /usr/share/dosh/examples/
ENTRYPOINT ["/bin/echo","Hello, world!"]
