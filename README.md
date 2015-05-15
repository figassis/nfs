# ObjectiveFS

The reliable POSIX shared file system that automatically scales to your
workload, works with your existing software and doesn’t need a storage cluster.

## Usage

First create your filesystem elsewhere. Then:

```sh
docker run \
	--privileged \
	-v /envdir:/envdir \
	-p 2049:2049 \
	-p 111:111
	-p 1062:1062 \
	-p 1063:1063 \
	-p 1064:1064 \
	-p 1065:1065 \
	-p 1066:1066 \
	eatnumber1/objectivefs \
	<bucket>
```
