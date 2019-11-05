FROM fedora:31
MAINTAINER Assis Ngolo <figassis@gmail.com>

ENV RPCBIND_ARGS=""
ENV RPC_IDMAPD_ARGS=""
ENV RPC_NFSD_ARGS=""
ENV RPC_NFSD_SERVER_COUNT="8"
ENV RPC_MOUNTD_ARGS=""
ENV NFS_CALLBACK_TCPPORT="1066"
ENV RPC_MOUNTD_PORT="1067"

ENV BUCKET=""

ENV OBJECTIVEFS_LICENSE=""

#The filesystem passphrase is required to mount your filesystem
ENV OBJECTIVEFS_PASSPHRASE=""

ENV AWS_ACCESS_KEY_ID=myawskeyid
ENV AWS_SECRET_ACCESS_KEY=myawssecretkey
ENV AWS_DEFAULT_REGION=us-east-1
#ENV AWS_TRANSFER_ACCELERATION=0

#Set cache size as a percentage of memory (e.g. 30%) or an absolute value (e.g. 500M or 1G). (Default: 20%)
ENV CACHESIZE="20%"

#<DISK CACHE SIZE>[:<FREE SPACE>]
ENV DISKCACHE_SIZE="2G:100G"


# Install prerequisites.
RUN yum -y update && yum -y install nfs-utils fuse python-setuptools nmap procps vim wget unzip git 
RUN yum clean all
ADD https://s3.amazonaws.com/files.nellcorp.com/assets/ofs/objectivefs-6.4-1.x86_64.rpm /
RUN yum -y install objectivefs-6.4-1.x86_64.rpm && rm objectivefs-6.4-1.x86_64.rpm

# Install supervisord
RUN yum install -y python2
RUN easy_install-2.7 -O2 supervisor supervisor-stdout && mkdir -p /var/log/supervisor
ADD etc/supervisord.conf /etc/
ADD etc/supervisord.d /etc/supervisord.d

# Install NFS
ADD etc/exports /etc/
ADD bin /opt/bin

# Install ObjectiveFS
RUN mkdir -p /objectivefs
VOLUME /objectivefs /var/cache/objectivefs

# nfs
EXPOSE 2049/tcp 2049/udp
# rpcbind
EXPOSE 111/tcp 111/udp
# nfs_callback_tcpport
EXPOSE 1066/tcp
# mountd
EXPOSE 1067/tcp 1067/udp

CMD ["/opt/bin/start_supervisord"]
