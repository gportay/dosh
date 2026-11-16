FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y asciidoctor
RUN apt-get update && apt-get install -y docker.io
RUN apt-get update && apt-get install -y sudo make fakeroot bash-completion zsh wget
RUN wget -O /etc/zsh/zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
ENTRYPOINT ["/bin/echo","Hello, world!"]
