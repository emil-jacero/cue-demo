# Example 3

## Summary

This examples used the built in module function to both get schemas and templates to render correct kubernetes manifest. It also uses the same delivery method (cue modules) to define `apps`, `collections` and `flavors`.

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

Upload supporting modules to the OCI registry. These modules are utilized by apps, bundles, flavors and cluster configurations.
They are mostly schemas and therefor are very generalized.

```shell
# Modules
cd $WDIR/cue-modules/k8s
cue mod tidy
cue mod publish v1.0.0

cd $WDIR/cue-modules/fluxv2
cue mod tidy
cue mod publish v1.0.0

cd $WDIR/cue-modules/common
cue mod tidy
cue mod publish v0.2.0

cd $WDIR/cue-modules/fluxcd
cue mod tidy
cue mod publish v0.2.0

cd $WDIR/cue-modules/bundle
cue mod tidy
cue mod publish v0.1.0

# Apps
cd $WDIR/cue-apps/podinfo
cue mod tidy
cue mod publish v0.4.0

cd $WDIR/cue-apps/grafana-operator
cue mod tidy
cue mod publish v0.4.0

cd $WDIR/cue-apps/prometheus
cue mod tidy
cue mod publish v0.4.0

cd $WDIR/cue-apps/alertmanager
cue mod tidy
cue mod publish v0.4.0

# Bundles
cd $WDIR/cue-bundles/obs-aio
cue mod tidy
cue mod publish v0.1.0

# Cluster
cd $WDIR/cue-modules/clusterv0
cue mod tidy
cue mod publish v0.7.0
```

## Run example

Prepp

```shell
cd $WDIR/example3
cue mod tidy
```

List all resources.
This will go through all apps, bundles and flavors, unpack them into the individual apps and then list them.

```shell
cue cmd ls
```

## Reflections

The flavor concept may not be required if instead bundles can be nested. When allowing for nested bundles it is up to the end-user how they want to combine them.
A sort of super bundle can be created that is similar to the flavor concept, in it will be opinionated to a specific cluster deployment.
