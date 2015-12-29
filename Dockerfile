FROM ubuntu:15.10
MAINTAINER Tim Haak <tim@haak.co>

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm"

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup &&\
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -q update && \
    apt-get -qy --force-yes dist-upgrade && \
    apt-get install -qy --force-yes \
      ca-certificates curl \
      openssl \
      sudo \
    && \
    curl --silent https://plex.tv/downloads#pms-desktop | \
    grep --extended-regexp --only-matching 'https://downloads.plex.tv/plex-media-server/.+/plexmediaserver_.+_amd64.deb' | \
    xargs curl --silent -O && \
    dpkg -i plexmediaserver_*_amd64.deb && \
    rm plexmediaserver_*_amd64.deb && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME ["/config","/data"]

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

ENV RUN_AS_ROOT="true" \
    CHANGE_DIR_RIGHTS="false" \
    CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"

EXPOSE 32400

CMD ["/start.sh"]

