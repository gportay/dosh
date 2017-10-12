FROM ubuntu:16.04
RUN apt-get update && apt-get install -y asciidoctor
RUN apt-get update && apt-get install -y zsh
RUN apt-get update && apt-get install -y wget
RUN wget -O /etc/zsh/zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
