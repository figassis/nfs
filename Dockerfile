FROM ubuntu:bionic

ADD docker-entrypoint.sh /

RUN apt-get update && apt-get -y install vim git procps unzip libfuse2 fuse rsyslog \
    software-properties-common \
    && add-apt-repository ppa:nfs-ganesha/libntirpc-3.0 \
    && add-apt-repository ppa:nfs-ganesha/nfs-ganesha-3.0 \
    # && add-apt-repository ppa:gluster/glusterfs-6 \
    && apt-get update \
    && apt-get -y install libntirpc3 nfs-ganesha nfs-ganesha-vfs nfs-ganesha-proxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/dbus /export \
    && chmod +x /docker-entrypoint.sh \
    #https://github.com/moby/moby/issues/4064
    && rm /etc/mtab && ln -s /proc/mounts /etc/mtab

ADD conf/ganesha.conf /etc/ganesha/

VOLUME /export

EXPOSE 2049/tcp

CMD ["/docker-entrypoint.sh"]