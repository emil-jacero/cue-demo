# Example 1

## Preparations

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

cd $WDIR/cue-modules/fluxcd
cue mod tidy
cue mod publish v0.4.0

cd $WDIR/cue-modules/bundle
cue mod tidy
cue mod publish v0.8.0

# Cluster
cd $WDIR/cue-modules/clusterv0
cue mod tidy
cue mod publish v0.7.0

# Apps
cd $WDIR/cue-apps/podinfo
cue mod tidy
cue mod publish v0.6.0

cd $WDIR/cue-apps/grafana-operator
cue mod tidy
cue mod publish v0.6.0

cd $WDIR/cue-apps/prometheus
cue mod tidy
cue mod publish v0.6.0

cd $WDIR/cue-apps/alertmanager
cue mod tidy
cue mod publish v0.6.0

cd $WDIR/cue-apps/cilium
cue mod tidy
cue mod publish v0.7.0

cd $WDIR/cue-apps/cinder-csi
cue mod tidy
cue mod publish v0.4.0
```

## Run example

Prepp

```shell
cd $WDIR/example2
cue mod tidy
```

List all apps

```shell
cue cmd ls_apps
```

List all Kubernetes resources

```shell
cue cmd ls_resources
```

View the manifest output

```shell
cue cmd view
```

Build the resources and output to yaml

```shell
cue cmd build
```
