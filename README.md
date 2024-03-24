# Cue Demo

## Description

This demo borrows some from this repo: <https://github.com/fluxcd/cues>

## Dependencies

- CUE == 0.8.0
- go == 1.21.0

## Prepp

### Registry

Pull and run a docker registry

```shell
docker run -d -p 5000:5000 --restart always --name registry registry:2
```

Destroy registry to cleanup

```shell
docker rm -f registry
```

### Cue

Enable the experimental cue modules support

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
```

## Developing own app

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
