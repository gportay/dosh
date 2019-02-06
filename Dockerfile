FROM ubuntu:16.04
RUN apt-get update && apt-get install -y asciidoctor
ENTRYPOINT ["/bin/echo","Hello, world!"]
