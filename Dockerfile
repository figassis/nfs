FROM ubuntu:bionic

# local, goofys, objectivefs
ENV STORAGE="local"

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION="us-east-1"
ENV BUCKET=""

#GOOFYS
ENV GOOFYS_DIR_MODE="0777"
ENV GOOFYS_FILE_MODE="0755"
ENV GOOFYS_UID=""
ENV GOOFYS_GID=""
ENV GOOFYS_ENDPOINT="s3.amazonaws.com"
ENV GOOFYS_REGION=${AWS_DEFAULT_REGION}
ENV GOOFYS_STORAGE_CLASS="STANDARD"
ENV GOOFYS_USE_CONTENT_TYPE=""
ENV GOOFYS_STAT_CACHE_TTL="1m0s"
ENV GOOFYS_TYPE_CACHE_TTL="1m0s"
ENV GOOFYS_GLOBAL_OPTION='-o nosuid,nodev,rw,allow_other,nonempty --cache "--free:10%:/var/cache/data"'
ENV GOOFYS_ETC_MIME=""

# OBJECTIVEFS
ENV OBJECTIVEFS_LICENSE=""

#The filesystem passphrase is required to mount your filesystem
ENV OBJECTIVEFS_PASSPHRASE=""

#ENV AWS_TRANSFER_ACCELERATION=0

#Set cache size as a percentage of memory (e.g. 30%) or an absolute value (e.g. 500M or 1G). (Default: 20%)
ENV CACHESIZE="20%"

#<DISK CACHE SIZE>[:<FREE SPACE>]
ENV DISKCACHE_SIZE="2G:100G"

COPY bin/goofys-v0.22.0 /usr/local/bin/goofys
COPY bin/catfs-v0.8.0 /usr/local/bin/catfs
ADD bin/objectivefs_6.4_amd64.deb /

ADD docker-entrypoint.sh /
ADD conf/local.conf /etc/
ADD conf/goofys.conf /etc/
ADD conf/objectivefs.conf /etc/

RUN apt-get update \
    && apt-get install -y libfuse2 fuse rsyslog nfs-ganesha nfs-ganesha-vfs nfs-ganesha-proxy vim git procps unzip supervisor \
    && dpkg -i objectivefs_6.4_amd64.deb \
    && rm objectivefs_6.4_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/dbus /var/run/dbus /export /var/cache/data /var/log/supervisor \
    && chmod +x /docker-entrypoint.sh /usr/local/bin/goofys /usr/local/bin/catfs \
    && rm /etc/mtab && ln -s /proc/mounts /etc/mtab

ADD conf/ganesha.conf /etc/ganesha/

VOLUME /export /var/cache/data

#EXPOSE 2049 111/tcp 111/udp 20048
EXPOSE 2049/tcp

CMD ["/docker-entrypoint.sh"]