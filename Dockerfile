FROM ubuntu:14.04.1
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -yq install \
        fuse 
RUN rm -rf /var/lib/apt/lists/*
ADD ./mount.objectivefs /sbin/
RUN chmod +x /sbin/mount.objectivefs
RUN mkdir /mnt/assets
RUN echo smilio-assets-frankfurt /mnt/assets objectivefs noauto 0 0 >> /etc/fstab
ADD includes /
RUN chmod +x *.sh
CMD /run.sh
