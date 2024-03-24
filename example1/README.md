# Example 1

## Summary

This examples focuses on deploying a simple module to a cluster

## Prepp

### Registry

Pull and run a docker registry.

```shell
docker run -d -p 5000:5000 --restart always --name registry registry:2
```

Destroy registry to cleanup.

```shell
docker rm -f registry
```

### Cue

Enable the experimental cue modules support.

```shell
export CUE_EXPERIMENT=modules
```

Set the OCI registry URL.

```shell
export CUE_REGISTRY=localhost:5000/cue-demo
```

Set a working directory. This should be the root of the git repo!

```shell
export WDIR=$(pwd)
```

Upload supporting modules to the OCI registry. These modules are utilized by apps, bundles, flavors and cluster configurations.
They are mostly schemas and therefor are very generalized.

```shell
cd $WDIR/cue-modules/k8s
cue mod tidy
cue mod publish v1.0.0

cd $WDIR/cue-modules/fluxv2
cue mod tidy
cue mod publish v1.0.0

cd $WDIR/cue-modules/common
cue mod tidy
cue mod publish v0.0.5

cd $WDIR/cue-modules/fluxcd
cue mod tidy
cue mod publish v0.0.5

cd $WDIR/cue-apps/podinfo
cue mod tidy
cue mod publish v0.0.5

cd $WDIR/cue-modules/clusterv0
cue mod tidy
cue mod publish v0.0.5
```

## Run example 1

Prepp

```shell
cd $WDIR/example1
cue mod tidy
```

List all resources.
This will go through all apps, bundles and flavors, unpack them into the individual apps and then list them.

```shell
cue cmd ls
```
