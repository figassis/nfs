FROM ubuntu:bionic

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION="us-east-1"
ENV AWS_S3_BUCKET=""

ENV BUCKET=""

ENV OBJECTIVEFS_LICENSE=""

#The filesystem passphrase is required to mount your filesystem
ENV OBJECTIVEFS_PASSPHRASE=""

#ENV AWS_TRANSFER_ACCELERATION=0

#Set cache size as a percentage of memory (e.g. 30%) or an absolute value (e.g. 500M or 1G). (Default: 20%)
ENV CACHESIZE="20%"

#<DISK CACHE SIZE>[:<FREE SPACE>]
ENV DISKCACHE_SIZE="2G:100G"

# install prerequisites
ADD https://s3.amazonaws.com/files.nellcorp.com/assets/ofs/objectivefs_6.4_amd64.deb /
RUN apt-get update \
    && apt-get install -y libfuse2 fuse rsyslog nfs-ganesha nfs-ganesha-vfs nfs-ganesha-proxy vim git procps unzip supervisor \
    && dpkg -i objectivefs_6.4_amd64.deb \
    && rm objectivefs_6.4_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/dbus


ADD docker-entrypoint.sh /
ADD ganesha.conf /etc/ganesha/
ADD supervisord.conf /etc/

RUN chmod +x /docker-entrypoint.sh && mkdir -p /objectivefs /var/log/supervisor

VOLUME /objectivefs

EXPOSE 2049 111/tcp 111/udp 20048

CMD ["/docker-entrypoint.sh"]