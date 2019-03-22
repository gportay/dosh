FROM ubuntu:16.04
RUN apt-get update && apt-get install -y asciidoctor
RUN apt-get update && apt-get install -y docker.io
RUN apt-get update && apt-get install -y make fakeroot
ADD dosh /usr/bin/
ENTRYPOINT ["/bin/echo","Hello, world!"]
