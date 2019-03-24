FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

ENV TOR_LANGUAGE en-US
ARG TOR_VERSION=8.0.0

RUN apt-get update && \
    apt-get install -y \
        iceweasel \
        xauth \
        xz-utils \
        wget && \
            apt-get clean

ENV HOME /home/tor

RUN useradd --create-home --home-dir $HOME tor && \
    chown -R tor:tor $HOME

RUN cd /tmp && \
    wget https://dist.torproject.org/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_${TOR_LANGUAGE}.tar.xz && \
    tar -vxJ --strip-components 1 -C /usr/local/bin -f tor-browser-linux64-${TOR_VERSION}_${TOR_LANGUAGE}.tar.xz && \
    chown -R tor:tor /usr/local/bin

WORKDIR $HOME
USER tor

CMD [ "/usr/local/bin/Browser/start-tor-browser", "--log", "/dev/stdout", "http://hss3uro2hsxfogfq.onion/" ]