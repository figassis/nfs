FROM ubuntu:14.04.1
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -yq install \
        fuse 
RUN rm -rf /var/lib/apt/lists/*
ADD ./mount.objectivefs /sbin/
RUN chmod +x /sbin/mount.objectivefs
RUN mkdir /objectivefs
ENTRYPOINT ["/sbin/mount.objectivefs", "-f", "-v"]
