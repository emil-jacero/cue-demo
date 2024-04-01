# Example 3

## Preparations

### Cue

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

# Bundles
cd $WDIR/cue-bundles/obs-aio
cue mod tidy
cue mod publish v0.9.0

cd $WDIR/cue-bundles/net-cilium
cue mod tidy
cue mod publish v0.9.0

cd $WDIR/cue-bundles/stor-o7k
cue mod tidy
cue mod publish v0.9.0

# Flavors
```

## Run example

Prepp

```shell
cd $WDIR/example3
cue mod tidy
```

List all apps

```shell
cue cmd ls_apps
```

List all bundles

```shell
cue cmd ls_bundles
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
