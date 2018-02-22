FROM debian:${DEBIAN_DISTRIBUTION}
MAINTAINER dev+docker@wazo.community

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /usr/src
RUN true && \
    apt-get -q update && \
    apt-get -q -y install apt-utils \
                          gnupg \
                          wget && \
    echo "deb http://mirror.wazo.community/archive/ wazo-${WAZO_VERSION} main" >> /etc/apt/sources.list.d/wazo-dist.list && \
    echo "deb-src http://mirror.wazo.community/archive/ wazo-${WAZO_VERSION} main" >> /etc/apt/sources.list.d/wazo-dist.list && \
    wget http://mirror.wazo.community/wazo_current.key -O - | apt-key add - && \
    apt-get -q update && \
    apt-get -q -y install asterisk \
                          asterisk-dbg \
                          dpkg-dev \
                          gdb \
                          libc6-dbg \
                          xivo-libsccp \
                          xivo-libsccp-dbg && \
    apt-get -q source asterisk && \
    true

CMD gdb asterisk /core $(find /usr/src/asterisk-* -type d -printf '-d %p ')
