# ObjectiveFS over NFS

The reliable POSIX shared file system that automatically scales to your
workload, works with your existing software and doesn’t need a storage cluster.

This container mounts an ObjectiveFS filesystem and serves it over NFS.

## Usage

First create your filesystem elsewhere. Then:

```sh
docker run \
	--privileged \
	-e AWS_ACCESS_KEY_ID=<key_id> \
	-e AWS_SECRET_ACCESS_KEY=<secret> \
	-e AWS_DEFAULT_REGION=<region> \
	-e OBJECTIVEFS_LICENSE=<license> \
	-e OBJECTIVEFS_PASSPHRASE=<pass> \
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

### Note
This is not a secure way to handle your ObjectiveFS passphrase or AWS secret
key. Make sure you run this container only on trusted hosts. Suggestions for
improvement are welcome!

## Limitations
 * Only one NFS server can be running on the host at a time.
 * The NFS and Portmap ports (`2049` and `111` respectively) cannot be changed.
