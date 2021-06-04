# build image: docker build . -t pass-menubar:testing
# run   image: docker run -it --rm -v $(pwd)/assets:/root/p -w /root/p pass-menubar:testing bash

FROM alpine:latest
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add pass words-en
