# Cue Demo

This demo borrows a lot from this repo: <https://github.com/fluxcd/cues>

## Description

This demo is designed to showcase a more advanced use-case of CUE and Kubernetes.

You will setup a few CUE modules that have the purpose of including the schemas of core components like the k8s api and fluxcd. Then you will add the `apps`, `bundles` and `flavors` as modules as well.

The demo will also introduce another module type that is called `cluster`.

### Apps

Apps are the smallest component meant to be a single deployment like `grafana-operator`. Due to the heavy reliance on helm-charts we have to use flux helmreleases for now, but they are still packaged as an `app`.

### Bundles

Bundles contain multiple `apps` and configuration to tie them together into a single deployable unit. This concept is borrowed from the [Timoni](https://timoni.sh/) project.
*I have another demo showcasing the same pattern but utilizing Timoni instead of only CUE [here](https://github.com/emil-jacero/timoni-demo)*

### Flavors

Flavors contain multiple `apps` and `bundles` but the difference is that a flavor is meant to be released and consumed as a whole opinionated configuration. Meaning the end-user which operates a k8s cluster only have to bump a single release for the flavor instead of bumping multiple bundles and apps.

Because the point of a flavor is to be opinionated and reused by multiple cluster we can only allow a single flavor per cluster. More on that below.

### Cluster

The cluster type is a specialized configuration that must include app/s, bundle/s or a flavor. The cluster configuration contains global variables like the cluster specific domain name (eg. `cl1.prod.example.com`).

When building the cluster configuration all the configuration from the apps, bundles and flavor is combined with the global variables into the output yaml.

## Dependencies

- go == 1.21.0
- CUE == 0.8.0

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

cd $WDIR/cue-modules/flux-release
cue mod tidy
cue mod publish v0.0.1

cd $WDIR/cue-modules/common
cue mod tidy
cue mod publish v0.0.1

cd $WDIR/cue-modules/app
cue mod tidy
cue mod publish v0.0.1

cd $WDIR/cue-modules/bundle
cue mod tidy
cue mod publish v0.0.1

cd $WDIR/cue-modules/flavor
cue mod tidy
cue mod publish v0.0.1

cd $WDIR/cue-modules/cluster
cue mod tidy
cue mod publish v0.0.1
```

## Developing your own app

### Prepp

Download go modules.
(These modules can later be used to generate CUE schemas)

```shell
export GO111MODULE=off
go get -d k8s.io/api/core/v1
go get -d k8s.io/api/apps/v1
go get -d k8s.io/api/networking/v1
go get -d k8s.io/apimachinery
go get -d k8s.io/apiextensions-apiserver
```

Optional: Generate cue schema from go modules

```shell
cue get go k8s.io/api/core/v1
cue get go k8s.io/api/apps/v1
cue get go k8s.io/api/networking/v1
cue get go k8s.io/apimachinery/pkg/apis/meta/v1
cue get go k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1
```
