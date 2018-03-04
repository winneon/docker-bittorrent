# Debian is preferred because of better support for building packages.
FROM debian:jessie
LABEL maintainer="Jesse Bryan <jesse@winneon.moe>"

# Set archive URLs & GitHub mirrors. SourceForge proves constantly that it is unreliable.
ENV NODEJS_URL https://deb.nodesource.com/setup_8.x
ENV XMLRPC_URL https://github.com/mirror/xmlrpc-c
ENV LIBTORRENT_URL https://github.com/rakshasa/libtorrent
ENV RTORRENT_URL https://github.com/rakshasa/rtorrent
ENV RUTORRENT_URL https://github.com/Novik/ruTorrent
ENV FLOOD_URL https://github.com/jfurrow/flood

# Set dependencies.
ENV REQ_DEPS "apache2-utils ca-certificates libc-ares2 mediainfo nginx php5-cli php5-fpm python2.7 screen sox unrar-free unzip"
ENV BUILD_DEPS "automake build-essential curl git libc-ares-dev libcurl4-openssl-dev libcppunit-dev"
ENV BUILD_DEPS "$BUILD_DEPS libncurses5-dev libtool libssl-dev libxml2-dev pkg-config"

# Set working directory to the system root.
WORKDIR /root

# Install build dependencies.
RUN set -x \
  && apt-get update \
  && apt-get install -q -y --no-install-recommends $REQ_DEPS \
  && apt-get install -q -y --no-install-recommends $BUILD_DEPS \
  && curl -sL $NODEJS_URL | bash - \
  && apt-get install -y nodejs \
  && npm install -g node-gyp

# Build xmlrpc-c because the debian package is out of date.
RUN set -x \
  && git clone $XMLRPC_URL \
  && cd xmlrpc-c/stable \
  && ./configure --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server \
  && make \
  && make install \
  && cd ../.. \
  && rm -rf xmlrpc-c \
  && ldconfig

# Build libtorrent because the debian package is out of date.
RUN set -x \
  && git clone $LIBTORRENT_URL \
  && cd libtorrent \
  && ./autogen.sh \
  && ./configure --with-posix-fallocate \
  && make \
  && make install \
  && cd .. \
  && rm -rf libtorrent \
  && ldconfig

# Build rtorrent because the debian package is out of date.
RUN set -x \
  && git clone $RTORRENT_URL \
  && cd rtorrent \
  && ./autogen.sh \
  && ./configure --with-xmlrpc-c --with-ncurses \
  && make \
  && make install \
  && cd .. \
  && rm -rf rtorrent \
  && ldconfig

# Install ffmpeg.
RUN echo "deb http://www.deb-multimedia.org jessie main" >> /etc/apt/sources.list \
  && apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A401FF99368FA1F98152DE755C808C2B65558117 \
  && apt-get update \
  && apt-get install -q -y --no-install-recommends deb-multimedia-keyring ffmpeg

# Create data directories.
RUN mkdir -p /data/rtorrent
RUN mkdir -p /data/rutorrent
RUN mkdir -p /data/flood

# Copy configuration files.
COPY configs/nginx.conf /etc/nginx/sites-available/default
COPY configs/rtorrent.rc /root/.rtorrent.rc

# Clone latest rutorrent archive & set the working directory.
WORKDIR /data/rutorrent
RUN git clone $RUTORRENT_URL .

# Configure rutorrent.
COPY configs/rutorrent.php conf/config.php

# Clone latest flood archive & set the working directory.
WORKDIR /data/flood
RUN git clone $FLOOD_URL .

# Configure flood.
COPY configs/flood.js config.js
RUN set -x \
  && npm install && npm cache clean --force \
  && npm run build \
  && mkdir -p /root/database

# Copy root files to the system root & set htpasswd.
COPY docker-bittorrent /usr/local/bin/docker-bittorrent
RUN htpasswd -cb /data/rutorrent/.htpasswd bittorrent bittorrent

# Expose volumes & ports.
EXPOSE 80 5000 6881
VOLUME [ "/data/rtorrent" ]

# Run the entrypoint.
ENTRYPOINT [ "/usr/local/bin/docker-bittorrent" ]
