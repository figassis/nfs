# ObjectiveFS over NFS

The reliable POSIX shared file system that automatically scales to your
workload, works with your existing software and doesn’t need a storage cluster.

This container mounts an ObjectiveFS filesystem and serves it over NFS.

## Usage

First create your filesystem elsewhere. Then:

```sh
docker run \
	--privileged \
	-v /envdir:/envdir \
	-p 2049:2049/tcp \
	-p 2049:2049/udp \
	-p 111:111/tcp \
	-p 111:111/udp \
	-p 1066:1066/tcp \
	-p 1067:1067/tcp \
	-p 1067:1067/udp \
	eatnumber1/objectivefs \
	<bucket>
```

Now you can `mount -t nfs -o nfsvers=4 hostname:/ /objectivefs`
.
